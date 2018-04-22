import copy, re
import scipy
import mnist
import scipy.misc
import numpy as np
from matplotlib import pyplot as plt

def step1():
    images = mnist.train_images()
    scipy.misc.toimage(scipy.misc.imresize(images[0, :, :] * -1 + 256, 10.))
    im_of_20 = np.zeros((20, 28, 28))
    for i in range(20):  # get the first 20 images to work with
        im_of_20[i, :, :] = images[i, :, :]
    im_of_20_map = np.where(im_of_20 < 128, -1, 1)
    return im_of_20_map

def step2(im_of_20_map):
    noise_df = np.loadtxt("NoiseCoordinates.csv", delimiter=',', usecols=range(1, 16), skiprows=1)
    im_of_20_noisy = copy.deepcopy(im_of_20_map)
    for i in range(20):
        for j in range(15):
            row = int(noise_df[i * 2, j])
            col = int(noise_df[i * 2 + 1, j])
            if im_of_20_noisy[i, row, col] == 1:
                im_of_20_noisy[i, row, col] = -1
            else:
                im_of_20_noisy[i, row, col] = 1
    # plt.imshow(im_of_20_noisy[0, :, :].astype(np.float64), cmap='gray')
    # plt.show()
    return im_of_20_noisy

def step3(im_of_20_noisy):
    initial_df = np.loadtxt("InitialParametersModel.csv", delimiter=',')  # 28x28
    update_df = np.loadtxt("UpdateOrderCoordinates.csv", delimiter=',', usecols=range(1, 785), skiprows=1)
    for i in range(10):
        for img in range(20):
            for idx in range(784):
                row_num = int(update_df[img * 2, idx])
                col_num = int(update_df[img * 2 + 1, idx])
                first_sum = 0
                sec_sum = 0
                third_sum = 0
                fourth_sum = 0
                if (row_num - 1) >= 0:
                    first_sum += 0.8 * (2 * initial_df[row_num - 1, col_num] - 1)
                    sec_sum += (2 * im_of_20_noisy[img, row_num - 1, col_num])
                    third_sum += -0.8 * (2 * initial_df[row_num - 1, col_num] - 1)
                    fourth_sum += (-2 * im_of_20_noisy[img, row_num - 1, col_num])
                if (row_num + 1) < 28:
                    first_sum += 0.8 * (2 * initial_df[row_num + 1, col_num] - 1)
                    sec_sum += (2 * im_of_20_noisy[img, row_num + 1, col_num])
                    third_sum += -0.8 * (2 * initial_df[row_num + 1, col_num] - 1)
                    fourth_sum += (-2 * im_of_20_noisy[img, row_num + 1, col_num])
                if (col_num - 1) >= 0:
                    first_sum += 0.8 * (2 * initial_df[row_num, col_num - 1] - 1)
                    sec_sum += (2 * im_of_20_noisy[img, row_num, col_num - 1])
                    third_sum += -0.8 * (2 * initial_df[row_num, col_num - 1] - 1)
                    fourth_sum += (-2 * im_of_20_noisy[img, row_num, col_num - 1])
                if (col_num + 1) < 28:
                    first_sum += 0.8 * (2 * initial_df[row_num, col_num + 1] - 1)
                    sec_sum += (2 * im_of_20_noisy[img, row_num, col_num + 1])
                    third_sum += -0.8 * (2 * initial_df[row_num, col_num + 1] - 1)
                    fourth_sum += (-2 * im_of_20_noisy[img, row_num, col_num + 1])
                numerator = np.exp(first_sum + sec_sum)
                denominator = numerator + np.exp(third_sum + fourth_sum)
                initial_df[row_num, col_num] = numerator / denominator
    initial_df1 = np.where(initial_df < 0.5, -1, 1)
    # plt.imshow(initial_df1.astype(np.float64), cmap='gray')
    # plt.show()

# Helper function to calculate E_q [log P]
def EQLOGP(imgIdx, initial_df, im_of_20_noisy):
    first_sum = 0
    sec_sum = 0
    for row in range(28):
        for col in range(28):
            if col - 1 >= 0:
                first_sum += 0.8 * (2 * initial_df[row, col] - 1) * (2 * initial_df[row, col - 1] - 1)
            if col + 1 < 28:
                first_sum += 0.8 * (2 * initial_df[row, col] - 1) * (2 * initial_df[row, col + 1] - 1)
            if row - 1 >= 0:
                first_sum += 0.8 * (2 * initial_df[row, col] - 1) * (2 * initial_df[row - 1, col] - 1)
            if row + 1 < 28:
                first_sum += 0.8 * (2 * initial_df[row, col] - 1) * (2 * initial_df[row + 1, col] - 1)
            sec_sum += 2 * (2*initial_df[row, col]-1) * (im_of_20_noisy[imgIdx, row , col ])
    return first_sum + sec_sum

# Helper function to calculate E_q [log Q]
def EQLOGQ(img, initial_df):
    eqlogq = 0
    for row in range(28):
        for col in range(28):
            eqlogq += initial_df[row, col] * (np.log(initial_df[row, col]) + (1e-10)) + \
                (1-initial_df[row, col])*(np.log(1-initial_df[row, col] + (1e-10)))
    return eqlogq

def step4(im_of_20_noisy):
    # loading the initial VFE
    initial_df = np.loadtxt("InitialParametersModel.csv", delimiter=',', dtype=np.float64)  # 28x28
    energy_list = np.zeros((20, 11))
    for imgIdx in range(20):
        first_sum = 0
        sec_sum = 0
        for row in range(28):
            for col in range(28):
                if (col - 1) >= 0:
                    first_sum += 0.8 * (2 * initial_df[row, col] - 1.0) * (2 * initial_df[row, col - 1] - 1.0)
                if (col + 1) < 28:
                    first_sum += 0.8 * (2 * initial_df[row, col] - 1.0) * (2 * initial_df[row, col + 1] - 1.0)
                if (row - 1) >= 0:
                    first_sum += 0.8 * (2 * initial_df[row, col] - 1.0) * (2 * initial_df[row - 1, col] - 1.0)
                if (row + 1) < 28:
                    first_sum += 0.8 * (2 * initial_df[row, col] - 1.0) * (2 * initial_df[row + 1, col] - 1.0)
                sec_sum += 2 * (2 * initial_df[row, col] - 1.0) * (im_of_20_noisy[imgIdx][row, col])

        energy_list[imgIdx, 0] = EQLOGQ(imgIdx, initial_df) - (first_sum + sec_sum)

    update_df = np.loadtxt("UpdateOrderCoordinates.csv", delimiter=',', usecols=range(1, 785), skiprows=1)
    for img in range(20):
        initial_df = np.loadtxt("InitialParametersModel.csv", delimiter=',')  # 28x28
        for i in range(1, 11):
            for idx in range(784):
                row_num = int(update_df[img * 2, idx])
                col_num = int(update_df[img * 2 + 1, idx])
                first_sum = 0
                sec_sum = 0
                third_sum = 0
                fourth_sum = 0
                if (row_num - 1) >= 0:
                    first_sum += 0.8 * (2 * initial_df[row_num - 1, col_num] - 1)
                    third_sum += -0.8 * (2 * initial_df[row_num - 1, col_num] - 1)
                if (row_num + 1) < 28:
                    first_sum += 0.8 * (2 * initial_df[row_num + 1, col_num] - 1)
                    third_sum += -0.8 * (2 * initial_df[row_num + 1, col_num] - 1)
                if (col_num - 1) >= 0:
                    first_sum += 0.8 * (2 * initial_df[row_num, col_num - 1] - 1)
                    third_sum += -0.8 * (2 * initial_df[row_num, col_num - 1] - 1)
                if (col_num + 1) < 28:
                    first_sum += 0.8 * (2 * initial_df[row_num, col_num + 1] - 1)
                    third_sum += -0.8 * (2 * initial_df[row_num, col_num + 1] - 1)
                sec_sum += (2 * im_of_20_noisy[img, row_num, col_num])
                fourth_sum += (-2 * im_of_20_noisy[img, row_num, col_num])

                numerator = np.exp(first_sum + sec_sum)
                denominator = numerator + np.exp(third_sum + fourth_sum)

                initial_df[row_num, col_num] = numerator / denominator
            energy_list[img, i] = EQLOGQ(img, initial_df) - EQLOGP(img, initial_df, im_of_20_noisy)
    print energy_list

    #Output to 2x2 matrix
    output_line = ''
    for img in (10,11):
        for i in (0,1):
            output_line+=str(energy_list[img, i])+','
        output_line=re.sub(',$', '\n', output_line)
    fw = open('energy.csv', 'w')
    fw.write(output_line)
    fw.close()

def step5(im_of_20_noisy):
    update_df = np.loadtxt("UpdateOrderCoordinates.csv", delimiter=',', usecols=range(1, 785), skiprows=1)
    a = []
    for img in range(20):
        initial_df = np.loadtxt("InitialParametersModel.csv", delimiter=',', dtype=np.float64)  # 28x28
        for i in range(10):
            for idx in range(784):
                row_num = int(update_df[img * 2, idx])
                col_num = int(update_df[img * 2 + 1, idx])
                first_sum = 0
                sec_sum = 0
                third_sum = 0
                fourth_sum = 0
                if (row_num - 1) >= 0:
                    first_sum += 0.8 * (2 * initial_df[row_num - 1, col_num] - 1)
                    third_sum += -0.8 * (2 * initial_df[row_num - 1, col_num] - 1)
                if (row_num + 1) < 28:
                    first_sum += 0.8 * (2 * initial_df[row_num + 1, col_num] - 1)
                    third_sum += -0.8 * (2 * initial_df[row_num + 1, col_num] - 1)
                if (col_num - 1) >= 0:
                    first_sum += 0.8 * (2 * initial_df[row_num, col_num - 1] - 1)
                    third_sum += -0.8 * (2 * initial_df[row_num, col_num - 1] - 1)
                if (col_num + 1) < 28:
                    first_sum += 0.8 * (2 * initial_df[row_num, col_num + 1] - 1)
                    third_sum += -0.8 * (2 * initial_df[row_num, col_num + 1] - 1)
                sec_sum += (2 * im_of_20_noisy[img, row_num, col_num])
                fourth_sum += (-2 * im_of_20_noisy[img, row_num, col_num])

                numerator = np.exp(first_sum + sec_sum)
                denominator = numerator + np.exp(third_sum + fourth_sum)

                initial_df[row_num, col_num] = numerator / denominator

        for row in range(28):
            for col in range(28):
                if (initial_df[row, col] < 0.5):
                    im_of_20_noisy[img, row, col] = 0
                else:
                    im_of_20_noisy[img, row, col] = 1
        a.append(im_of_20_noisy[img])

    # Output to 28x280 matrix file
    output_line = ''
    for row in range(28):
        for img in range(10,20):
            for col in range(28):
                output_line+=str(im_of_20_noisy[img, row, col])+','
        output_line = re.sub(',$', '\n', output_line)
    fw = open('denoised.csv', 'w')
    fw.write(output_line)
    fw.close()

def main():
    #1. Get the first 20
    im_of_20_map = step1()

    #2. Add noise
    im_of_20_noisy = step2(im_of_20_map)

    #3 Mean Field Inference
    step3(im_of_20_noisy)

    #4 Energy function values iteration
    step4(im_of_20_noisy)

    #5 Resonstruct images
    step5(im_of_20_noisy)

if __name__ == "__main__":
    main()