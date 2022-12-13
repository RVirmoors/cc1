import os
import sys
sys.path.append('stylegan3-fun')

#import dlib # requires cmake
#from align_face import align_face
import numpy as np
from Library.Spout import Spout

import copy
from time import perf_counter

import click
import torch
import torch.nn.functional as F

import dnnlib
from dnnlib.util import format_time
import legacy

from torch_utils import gen_utils
from pytorch_ssim import SSIM  # from https://github.com/Po-Hsun-Su/pytorch-ssim

from network_features import VGG16FeaturesNVIDIA, DiscriminatorFeatures
from metrics import metric_utils


# =======================
@click.command()
@click.pass_context
@click.option('--network', '-net', 'network_pkl', help='Network pickle filename', default="E:\sg3-pretrained\stylegan2-afhqdog-512x512.pkl", show_default=True)
@click.option('--init-lr', '-lr', 'initial_learning_rate', type=float, help='Initial learning rate of the optimization process', default=0.02, show_default=True)
# =======================


def run_projection(
        ctx: click.Context,
        network_pkl: str,
        initial_learning_rate: float,
        w_avg_samples: int = 10000,
        initial_noise_factor: float = 0.05,
        regularize_noise_weight: float = 1e5,
):
    """
    Project given image to the latent space of pretrained network pickle.
    Adapted from stylegan3-fun/projector.py
    """
    torch.manual_seed(42)

    # Load networks.
    print('Loading networks from "%s"...' % network_pkl)
    device = torch.device('cuda')
    with dnnlib.util.open_url(network_pkl) as fp:
        G = legacy.load_network_pkl(fp)['G_ema'].requires_grad_(False).to(device)

    # Open Spout stream for target images
    spout = Spout(silent = False, width = 640, height = 480) # TODO set W and H to 720p ?
    spout.createReceiver('input')
    spout.createSender('output')

    # Stabilize the latent space to make things easier (for StyleGAN3's config t and r models)
    gen_utils.anchor_latent_space(G)

    # == Adapted from project() in stylegan3-fun/projector.py == #

    G = copy.deepcopy(G).eval().requires_grad_(False).to(device)
    # Compute w stats.
    z_samples = np.random.RandomState(123).randn(w_avg_samples, G.z_dim)
    w_samples = G.mapping(torch.from_numpy(z_samples).to(device), None)  # [N, L, C]
    print('Projecting in W+ latent space...')
    w_avg = torch.mean(w_samples, dim=0, keepdim=True)  # [1, L, C]
    w_std = (torch.sum((w_samples - w_avg) ** 2) / w_avg_samples) ** 0.5
    # Setup noise inputs (only for StyleGAN2 models)
    noise_buffs = {name: buf for (name, buf) in G.synthesis.named_buffers() if 'noise_const' in name}
    w_noise_scale = w_std * initial_noise_factor # noise scale is constant
    lr = initial_learning_rate # learning rate is constant

    # Load the VGG16 feature detector.
    url = 'e:/sg3-pretrained/metrics/vgg16.pkl'
    vgg16 = metric_utils.get_feature_detector(url, device=device)

    print("Loaded vgg16...")

    w_opt = w_avg.clone().detach().requires_grad_(True)
    optimizer = torch.optim.Adam([w_opt] + list(noise_buffs.values()), betas=(0.9, 0.999), lr=initial_learning_rate)
    for param_group in optimizer.param_groups:
        param_group['lr'] = lr

    # Init noise.
    for buf in noise_buffs.values():
        buf[:] = torch.randn_like(buf)
        buf.requires_grad = True       
    # == End setup from project() == #

    # Project continuously
    while True :
        # check on close window
        spout.check()
        # receive data
        data = spout.receive()
        # data = align_face(data, G.img_resolution) ## TOO SLOW !!!
        #print(data.shape)
        
        # Features for target image. Reshape to 256x256 if it's larger to use with VGG16
        # target = np.array(target, dtype=np.uint8)
        target = torch.tensor(data.transpose([2, 0, 1]), device=device)
        target = target.unsqueeze(0).to(device).to(torch.float32)
        if target.shape[2] > 256:
            target = F.interpolate(target, size=(256, 256), mode='area')
        target_features = vgg16(target, resize_images=False, return_lpips=True)

        # Synth images from opt_w.
        w_noise = torch.randn_like(w_opt) * w_noise_scale
        ws = w_opt + w_noise
        synth_images = G.synthesis(ws, noise_mode='const')
        # Downsample image to 256x256 if it's larger than that. VGG was built for 224x224 images.
        synth_images = (synth_images + 1) * (255/2)
        if synth_images.shape[2] > 256:
            synth_images = F.interpolate(synth_images, size=(256, 256), mode='area')

        # Features for synth images.
        synth_features = vgg16(synth_images, resize_images=False, return_lpips=True)
        dist = (target_features - synth_features).square().sum()

        # Noise regularization.
        reg_loss = 0.0
        for v in noise_buffs.values():
            noise = v[None, None, :, :]  # must be [1,1,H,W] for F.avg_pool2d()
            while True:
                reg_loss += (noise * torch.roll(noise, shifts=1, dims=3)).mean() ** 2
                reg_loss += (noise * torch.roll(noise, shifts=1, dims=2)).mean() ** 2
                if noise.shape[2] <= 8:
                    break
                noise = F.avg_pool2d(noise, kernel_size=2)
        loss = dist + reg_loss * regularize_noise_weight
        # Print in the same line (avoid cluttering the commandline)
        message = f'dist {dist:.7e} | loss {loss.item():.7e}'
        print(message, end='\r')

        # Step
        optimizer.zero_grad(set_to_none=True)
        loss.backward()
        optimizer.step()
        
        # Normalize noise.
        with torch.no_grad():
            for buf in noise_buffs.values():
                buf -= buf.mean()
                buf *= buf.square().mean().rsqrt()

        # Produce image
        data = gen_utils.w_to_img(G, dlatents=w_opt.detach()[0], noise_mode='const')[0]

        spout.send(data)


# === MAIN ===

if __name__ == "__main__":
    run_projection()  # pylint: disable=no-value-for-parameter