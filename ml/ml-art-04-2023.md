# iML Art 04.2023 // [bit.ly/ml-0423](https://bit.ly/ml-0423)

[Grigore Burloiu](https://cinetic.arts.ro/en/echipa/grigore-burloiu/) . [web](https://rvirmoors.github.io/) . [ITPMA](https://itpma.notion.site/)

ethics
- [76 reasonable questions](https://76questions.neocities.org/)

disclaimer: just some tools!
- no slides[*](https://rvirmoors.github.io/ccia/slides/intro-ml-workshop)[*](https://rvirmoors.github.io/ccia/slides/stylegan-workshop)
- no coding (i hope!)
- no math (almost)
- no art

0. [How to use this repo](#howto)
1. pose in: [PoseNet](#posenet)
2. audio gen out: [RAVE](#rave)
3. image gen out: [StyleGAN (via FluCoMa)](#stylegan)
4. text out: [GPT4All](#gpt)
5. text to image: [Stable Diffusion](#stablediffusion)

---

## howto

1. clone this repo to your (windows) PC
2. open/run each file/script as instructed

see the video recording for details

## posenet

- requires: [Max 8](https://cycling74.com/downloads)
- source: https://github.com/yuichkun/n4m-posenet

open `cc1/ml/posenet/hands.maxpat`

## rave

- requires: Max 8
- source: https://github.com/acids-ircam/nn_tilde

open `cc1/ml/nn-rave/blabber.maxpat`

## stylegan

- requires: Max 8 with [FluCoMa](https://www.flucoma.org/download/)
- requires: Python 3.9 64bit
- requires: NVidia GPU w/ CUDA drivers
- source: https://github.com/PDillis/stylegan3-fun

[install](stylegan3/startup.txt) StyleGAN3 and trained models

open `cc1/ml/stylegan3/pose-gan.maxpat`

open a terminal in `cc1/ml/stylegan3` and run `python gan.py`

## gpt

- source: https://github.com/nomic-ai/gpt4all
- source: https://youtu.be/eztLFYkJqz8 (text-to-speech)

## stablediffusion

- source: https://github.com/Stability-AI/StableDiffusion
- source: https://github.com/CompVis/stable-diffusion


stable diffusion with stylegan-like interpolation? [why not](https://sites.google.com/view/stylegan-t/)