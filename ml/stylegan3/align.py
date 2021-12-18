import time
import dlib # requires cmake
import numpy as np
from align_face import align_face
from Library.Spout import Spout

spout = Spout(silent = False, width = 1044, height = 1088)
spout.createReceiver('input')
spout.createSender('output')

while True :
    # check on close window
    spout.check()
    # receive data
    data = spout.receive()#.astype(np.uint8)
    print(data.shape)
    data = align_face(data)
    print(data.shape)
    spout.send(data)