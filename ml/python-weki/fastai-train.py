# use data/pull, data/release as classes,
# export fine-tuned resnet34 model

import torch.cuda
if torch.cuda.is_available():
    print('PyTorch found cuda - device #' + torch.cuda.current_device())
else:
    print('PyTorch could not find cuda')

from fastai.vision.all import *

path = Path('D:\LYON 2021/cc1/ml/python-weki/data') #Path().resolve() # current path
dls = ImageDataLoaders.from_folder(path, train='.', valid_pct=0.1, bs=8, num_workers=0) # num_workers=0 avoids forking
print(dls.valid_ds.items[:3])

learn = cnn_learner(dls, resnet34, metrics=error_rate)
#print(learn.lr_find())

#learn.fine_tune(1, 0.001)

print( learn.predict('data/pull/10.jpg') )

# Export our trained model in form of pickle file
DIR = 'data/models/'
noFiles = len([name for name in os.listdir(DIR) if os.path.isfile(os.path.join(DIR, name))])
pickleName = 'models/classifier' + str(noFiles) + '.pkl'
#learn.export(fname=pickleName)