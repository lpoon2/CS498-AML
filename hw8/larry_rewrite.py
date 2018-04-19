import os, struct
import math, random, copy
import numpy as np
import sys
from scipy import misc
import math
import matplotlib.pyplot as plt
import numpy as np
import scipy
from matplotlib import pyplot as plt
import pandas as pd
import mnist
import scipy.misc

images = mnist.train_images()
im_of_20 = np.zeros((20, 28, 28))
im_of_20_flip = np.zeros((20, 28, 28))

for i in range(20): #get the first 20 images to work with
    im_of_20[i,:,:] = images[i,:,:]

im_of_20_map = np.where(im_of_20 < 128.0 ,-1,1)
'''
2
'''
noise_df = np.loadtxt("NoiseCoordinates.csv", delimiter= ',',  usecols=range(1,16), skiprows=1)
for i in range(20):
    for j in range(15):
        row = int(noise_df[i*2,j])
        col = int(noise_df[i*2+1,j])
        if im_of_20_map[i, row, col] == 1:
            im_of_20_map[i, row, col] = -1
        else:
            im_of_20_map[i, row, col] = 1
'''
4
'''
'''
Helper function to calculate E_q [log Q]
'''
def EQLOGQ(img):
    eqlogq = 0
    for row in range(28):
        for col in range(28):
            eqlogq += initial_df[row, col] * (np.log(initial_df[row, col]) + (10e-10)) + \
                (1-initial_df[row, col])*(np.log(1-initial_df[row, col] + (10e-10)))
    return eqlogq

initial_df = np.loadtxt("InitialParametersModel.csv", delimiter= ',') # 28x28
#initial_df = np.transpose(initial_df)
energy_list = np.zeros((20,11))
for imgIdx in range(20):
    first_sum = 0
    sec_sum = 0
    for row in range(28):
        for col in range(28):
            if (col - 1) >= 0:
                first_sum += 0.8 * (2 * initial_df[row, col] - 1) * (2 * initial_df[row, col - 1] - 1)
            if (col + 1) < 28:
                first_sum += 0.8 * (2 * initial_df[row, col] - 1) * (2 * initial_df[row, col + 1] - 1)
            if (row - 1) >= 0:
                first_sum += 0.8 * (2 * initial_df[row, col] - 1) * (2 * initial_df[row - 1, col] - 1)
            if (row + 1) < 28:
                first_sum += 0.8 * (2 * initial_df[row, col] - 1) * (2 * initial_df[row + 1, col] - 1)
            sec_sum += 2 * (2 * initial_df[row, col] - 1) * (im_of_20_map[imgIdx,row, col])
    print str(first_sum) + ',' + str(sec_sum)
    eqlogq = 0
    for row in range(28):
        for col in range(28):
            eqlogq += initial_df[row, col] * (np.log(initial_df[row, col]) + (10e-10)) + \
                (1-initial_df[row, col])*(np.log(1-initial_df[row, col] + (10e-10)))
    energy_list[imgIdx,0] = eqlogq - (first_sum + sec_sum)
print energy_list
