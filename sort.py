import argparse
import numpy as np
import os
import imutils
import cv2
import random

# print(cv2.__version__)

def parse_args():
	desc = "Tools to normalize an image dataset" 
	parser = argparse.ArgumentParser(description=desc)

	parser.add_argument('--verbose', action='store_true',
		help='Print progress to console.')

	parser.add_argument('--exact', action='store_true',
		help='match to exact specs')

	parser.add_argument('--input_folder', type=str,
		default='./input/',
		help='Directory path to the inputs folder. (default: %(default)s)')

	parser.add_argument('--output_folder', type=str,
		default='./output/',
		help='Directory path to the outputs folder. (default: %(default)s)')

	parser.add_argument('--process_type', type=str,
		default='exclude',
		help='Process to use. ["exclude","sort"] (default: %(default)s)')

	parser.add_argument('--max_size', type=int, 
		default=2048,
		help='Maximum width or height of the output images. (default: %(default)s)')

	parser.add_argument('--min_size', type=int, 
		default=1024,
		help='Maximum width or height of the output images. (default: %(default)s)')

	parser.add_argument('--min_ratio', type=float, 
		default=1.0,
		help='Ratio of image (height/width). (default: %(default)s)')

	parser.add_argument('--file_extension', type=str,
		default='png',
		help='file type ["png","jpg"] (default: %(default)s)')



	args = parser.parse_args()
	return args



def exclude(img,filename):
	make_path = args.output_folder + "exclude_"+str(args.min_size)+"-"+str(args.max_size)+"/"
	if not os.path.exists(make_path):
		os.makedirs(make_path)

	(h, w) = img.shape[:2]

	if((h >= args.min_size) and (h <= args.max_size) and (w >= args.min_size) and (w <= args.max_size)):

		if(args.file_extension == "png"):
			new_file = os.path.splitext(filename)[0] + ".png"
			cv2.imwrite(os.path.join(make_path, new_file), img, [cv2.IMWRITE_PNG_COMPRESSION, 0])
		else:
			new_file = os.path.splitext(filename)[0] + ".jpg"
			cv2.imwrite(os.path.join(make_path, new_file), img, [cv2.IMWRITE_JPEG_QUALITY, 90])

def sort(img,filename):
	make_path1 = args.output_folder + "yes/"
	make_path2 = args.output_folder + "no/"
	if not os.path.exists(make_path1):
		os.makedirs(make_path1)
	if not os.path.exists(make_path2):
		os.makedirs(make_path2)

	(h, w) = img.shape[:2]
	ratio = h/w

	if(args.exact == True):
		if((ratio >= 1.0) and (h == args.max_size) and (w == args.min_size)):
			path = make_path1
		elif((ratio < 1.0) and (w == args.max_size) and (h == args.min_size)):
			path = make_path1
		else:
			path = make_path2
	else:
		#only works with ratio right now
		if(ratio>=args.min_ratio):
			path = make_path1
		else:
			path = make_path2

	if(args.file_extension == "png"):
		new_file = os.path.splitext(filename)[0] + ".png"
		cv2.imwrite(os.path.join(path, new_file), img, [cv2.IMWRITE_PNG_COMPRESSION, 0])
	else:
		new_file = os.path.splitext(filename)[0] + ".jpg"
		cv2.imwrite(os.path.join(path, new_file), img, [cv2.IMWRITE_JPEG_QUALITY, 90])
def processImage(img,filename):

	if args.process_type == "exclude":	
		exclude(img,filename)
	if args.process_type == "sort":	
		sort(img,filename)

def main():
	global args
	global count
	global inter
	args = parse_args()
	count = int(0)
	inter = cv2.INTER_CUBIC
	os.environ['OPENCV_IO_ENABLE_JASPER']= "true"
	print('processing images...')

	for root, subdirs, files in os.walk(args.input_folder):
		if(args.verbose): print('--\nroot = ' + root)

		for subdir in subdirs:
			if(args.verbose): print('\t- subdirectory ' + subdir)

		for filename in files:
			file_path = os.path.join(root, filename)
			if(args.verbose): print('\t- file %s (full path: %s)' % (filename, file_path))
			
			img = cv2.imread(file_path)

			if hasattr(img, 'copy'):
				processImage(img,filename)
				count = count + int(2)


if __name__ == "__main__":
	main()