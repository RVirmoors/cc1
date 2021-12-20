import time
import dlib # requires cmake
import numpy as np
from align_face import align_face
from Library.Spout import Spout

spout = Spout(silent = False, width = 1044, height = 1088)
spout.createReceiver('input')
spout.createSender('output')

# python projector.py --target=out/seed0002.png --project-in-wplus --save-video --num-steps=1000 --network=https://api.ngc.nvidia.com/v2/models/nvidia/research/stylegan3/versions/1/files/stylegan3-r-afhqv2-512x512.pkl

while True :
    # check on close window
    spout.check()
    # receive data
    data = spout.receive()
    print(data.shape)
    data = align_face(data)
    print(data.shape)
    spout.send(data)