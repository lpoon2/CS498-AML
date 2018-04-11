%% Mean field inference for binary images
% The MNIST dataset consists of 60, 000 images of handwritten digits, 
% curated by Yann LeCun, Corinna Cortes, and Chris Burges. You can find it 
% here, together with a collection of statistics on recognition, etc. We
% will use the first 500 of the training set images.

%% a)
% Obtain the MNIST training set, and binarize the first 500 images by 
% mapping any value below .5 to -1 and any value above to 1. For each 
% image, create a noisy version by randomly flipping 2% of the bits.
clc; clear all; close all;

images_all = loadMNISTImages('train-images-idx3-ubyte');
labels_all = loadMNISTLabels('train-labels-idx1-ubyte');

images = images_all(:,1:500)';
labels = labels_all(1:500);

clear images_all labels_all;

images(images >= 0.5) =  1;
images(images <  0.5) = -1;

images = int8(images);
images_original = images;

num_rand_flips = floor(784 * 0.02);
rand_indices = randi([1 784], 500, num_rand_flips);

for image = 1:500
    for pixel = rand_indices(image, :)
        images(image, pixel) = -images(image, pixel);
    end
end

clear num_rand_flips rand_indices image pixel

%% b)
% Now denoise each image using a Boltzmann machine model and mean field
% inference. Use theta_{ij}=0.2 for the H_i, H_j terms and theta_{ij}=2 for
% the H_i, X_j terms. To hand in: Report the fraction of all pixels that 
% are correct in the 500 images.

theta_1 = 0.2;
theta_2 =   2;

accurracy = zeros(500, 1);

for image_idx = 1:500
    image_idx
    image = reshape(images(image_idx, :), [28 28]);
    guess = denoise(image, theta_1, theta_2);

    original = reshape(images_original(image_idx, :), [28 28]);    
    accurracy(image_idx) = sum(sum(original == guess))/(28*28);
end


%% To hand in: 
% Prepare a figure showing the original image, the noisy image, and the 
% reconstruction for your most accurate reconstruction your least accurate.
% Assume that theta_{ij} for the H_i, H_j terms takes a constant value c.
close all;

[max_val, max_idx] = max(accurracy);
[min_val, min_idx] = min(accurracy);

for idx = [max_idx, min_idx]
    image    = reshape(images(idx, :), [28 28]);
    guess    = denoise(image, theta_1, theta_2);
    original = reshape(images_original(idx, :), [28 28]);
    
    figure; 
    imshow(image, [-1 1]);
    title('noisy');
    
    figure;
    imshow(guess, [-1 1]);
    title('guess');

    figure;
    imshow(original, [-1 1]);
	title('original');
end

%%
% A receiver operating curve is a curve plotting the true positive rate against the
% false positive rate for a predictor, for different values of some useful
% parameter. We will use c as our parameter. To hand in: Using at least
% five values of c in the range -1 to 1, plot a receiver operating curve
% for your denoising algorithm.

thetas = [-0.5 -0.25 0 0.25 0.5];
true_positive = zeros(5,1);
false_positive = zeros(5,1);
real_positive = zeros(5,1);
one_array = ones(28, 28);
for i = 1:5
    theta_1 = thetas(i);
    for idx = 1:500
        idx
        theta_1
        image    = reshape(images(idx, :), [28 28]);
        guess    = denoise(image, theta_1, theta_2);
        original = reshape(images_original(idx, :), [28 28]);
        true_positive(i) = true_positive(i) + sum(sum(original == guess & guess == one_array));
        false_positive(i) = false_positive(i) + sum(sum(original ~= guess & guess == one_array));
        real_positive(i) = real_positive(i) + sum(sum(original == one_array));
    end
end
%Using true positives as one axis, and false positives as the next, plot a
%point with the respective thetas

true_positive = true_positive ./ real_positive;
false_positive = false_positive ./ real_positive;
figure;
hold;
scatter(false_positive, true_positive, [], [1 2 3 4 5])
hold;
xlim([0 1]);
ylim([0 1]);