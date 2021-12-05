# use data/pull, data/release as classes,
# import fine-tuned resnet34 model

import time
from Library.Spout import Spout
from fastai.vision.all import *

from pythonosc.udp_client import SimpleUDPClient
client = SimpleUDPClient("127.0.0.1", 12000)

import torch.cuda
if torch.cuda.is_available():
    print('PyTorch found cuda - device ' + str(torch.cuda.current_device()))
else:
    print('PyTorch could not find cuda')

DIR = 'data/models/'
noFiles = len([name for name in os.listdir(DIR) if os.path.isfile(os.path.join(DIR, name))])
pickleName = 'data/models/classifier' + str(noFiles - 1) + '.pkl'
learn = load_learner(pickleName, cpu=False)
print("Loaded model: " + pickleName)

print(next(learn.model.parameters()).is_cuda)

# create spout object
spout = Spout(silent = False, width = 1280, height = 720, n_rec = 3)
# create receiver
spout.createReceiver('input1', id = 0)
spout.createReceiver('input2', id = 1)
spout.createReceiver('input3', id = 2)

lookAt = 0

while True :

    # check on close window
    spout.check()
    # receive data
    data = spout.receive(id = lookAt)
    # predict
    result = learn.predict(data)
    print(lookAt, ":", result)
    client.send_message("/detect", [lookAt, result[0]])
    time.sleep(0.2)
    lookAt = (lookAt + 1) % 3


