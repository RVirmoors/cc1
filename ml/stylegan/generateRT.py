import argparse
import sys
import os
import subprocess
import pickle
import re

import scipy
import numpy as np
import PIL.Image

import dnnlib
import dnnlib.tflib as tflib

os.environ['PYGAME_HIDE_SUPPORT_PROMPT'] = "hide"
from opensimplex import OpenSimplex

import warnings  # mostly numpy warnings for me
warnings.filterwarnings('ignore', category=FutureWarning)
warnings.filterwarnings('ignore', category=DeprecationWarning)

# ==================================

# spout stuff
from Library.Spout import Spout
import random

# OSC stuff
from pythonosc.dispatcher import Dispatcher

dispatcher = Dispatcher()

psi = 1
z = np.zeros((1, 512))


def getPsiOSC(address, *args):
    global psi
    psi = args[0]
#	print("GOT PSI", psi)


def getZOSC(address, *args):
    global z
    z = np.array(args).reshape(1, 512)


dispatcher.map("/psi", getPsiOSC)
dispatcher.map("/wek/outputs", getZOSC)

from pythonosc.osc_server import BlockingOSCUDPServer
server = BlockingOSCUDPServer(("127.0.0.1", 5006), dispatcher)


def main():
    parser = argparse.ArgumentParser(
        description='Generate images using pretrained network pickle.',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    subparsers = parser.add_subparsers(help='Sub-commands', dest='command')
    parser_generate_images = subparsers.add_parser(
        'generate-images', help='Generate images')
    parser_generate_images.add_argument(
        '--network', help='Network pickle filename', dest='network_pkl', required=True)
    parser_generate_images.set_defaults(func=generate_images)

    args = parser.parse_args()
    kwargs = vars(args)
    subcmd = kwargs.pop('command')

    if subcmd is None:
        print('Error: missing subcommand.  Re-run with --help for usage.')
        sys.exit(1)

    func = kwargs.pop('func')
    func(**kwargs)

# start generating
# generate_images()


# =============================

def generate_images(network_pkl):

    global z

    tflib.init_tf()
    print('Loading networks from "%s"...' % network_pkl)
    with dnnlib.util.open_url(network_pkl) as fp:
        _G, _D, Gs = pickle.load(fp)

    Gs_kwargs = {
        'output_transform': dict(func=tflib.convert_images_to_uint8, nchw_to_nhwc=True),
        'randomize_noise': False
    }

    noise_vars = [var for name, var in Gs.components.synthesis.vars.items(
    ) if name.startswith('noise')]
    label = np.zeros([1] + Gs.input_shapes[1][1:])

    # create spout object
    spout = Spout(silent=False, width=512, height=512)
# create sender
    spout.createSender('output')

    while True:

        # check on close window
        spout.check()

        server.handle_request()
        Gs_kwargs['truncation_psi'] = psi

    # GENERATION:
        seed = 74  # random.randrange(9999)
        rnd = np.random.RandomState(seed)
        # z = rnd.randn(1, *Gs.input_shape[1:]) # [minibatch, component]

        noise_rnd = np.random.RandomState(1)  # fix noise
        tflib.set_vars({var: noise_rnd.randn(*var.shape.as_list())
                        for var in noise_vars})  # [height, width]

        image = Gs.run(z, label, **Gs_kwargs)

    # send data
        spout.send(image[0])


# ========================

if __name__ == "__main__":
    main()
