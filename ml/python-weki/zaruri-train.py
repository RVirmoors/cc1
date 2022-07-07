# use data-zaruri/1,2,3... as classes,
# export fine-tuned resnet34 model

import torch.cuda
if torch.cuda.is_available():
    print('PyTorch found cuda - device ' + str(torch.cuda.current_device()))
else:
    print('PyTorch could not find cuda')

from fastai.vision.all import *

path = Path('C:\Users\rv\Documents\cc1\ml\python-weki\data-zaruri') #Path().resolve() # current path?
dls = ImageDataLoaders.from_folder(path, train='.', valid_pct=0.1, bs=8, num_workers=0) # num_workers=0 avoids forking
print(dls.valid_ds.items[:])

learn = cnn_learner(dls, resnet34, metrics=error_rate)
#print(learn.lr_find())

learn.fine_tune(20, 0.002)

print( learn.predict('data-zaruri/1/1.jpg') )

# Export our trained model in form of pickle file
DIR = 'data-zaruri/models/'
noFiles = len([name for name in os.listdir(DIR) if os.path.isfile(os.path.join(DIR, name))])
pickleName = 'models/classifier' + str(noFiles) + '.pkl'
learn.export(fname=pickleName)