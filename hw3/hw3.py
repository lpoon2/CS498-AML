
# coding: utf-8

# In[312]:

import numpy as np
import os
import pandas as pd
import csv
from sklearn.decomposition import PCA
from matplotlib import pyplot as plt
import matplotlib.pyplot as pyplot
import PIL.Image as Image
from PIL import ImageOps
from sklearn.metrics.pairwise import euclidean_distances
from sklearn.metrics.pairwise import paired_distances
from sklearn.manifold import MDS


# In[199]:

labels =['airplane', 'automobile', 'bird', 'cat', 'deer', 'dog', 'frog', 'horse', 'ship', 'truck'];


# ### load data (Only taking data_batch_1 for now for all training to limit training time)

# In[132]:

def unpickle(file):
    import pickle
    with open(file, 'rb') as fo:
        dict = pickle.load(fo, encoding='bytes')
    return dict


# In[269]:

data_batch_1 = unpickle("C:/Users/titus/Documents/CS498/hw3/data_batch_1")
data_batch_2 = unpickle("C:/Users/titus/Documents/CS498/hw3/data_batch_2")
data_batch_3 = unpickle("C:/Users/titus/Documents/CS498/hw3/data_batch_3")
data_batch_4 = unpickle("C:/Users/titus/Documents/CS498/hw3/data_batch_4")
data_batch_5 = unpickle("C:/Users/titus/Documents/CS498/hw3/data_batch_5")
test_batch = unpickle("C:/Users/titus/Documents/CS498/hw3/test_batch")


# In[5]:

data_batch_1.keys()


# In[69]:

data_batch_1[b'data'].shape


# In[70]:

print(data_batch_1)


# ### 1a: Mean image 

# In[143]:

sum_mean = np.zeros((10,3072))
count = np.zeros(10)
#sum over all the image data for each category 
for i in range (0, 10000):
    sum_mean[data_batch_1[b'labels'][i]] += data_batch_1[b'data'][i]
    count[data_batch_1[b'labels'][i]] += 1


# In[223]:

print(count)


# In[144]:

#devide by the number of picture it has in that category to get the mean image 
for i in range (0, 10):
    mean[i]=sum_mean[i]/count[i]


# In[145]:

print(mean[4])


# In[146]:

mean.shape


# In[147]:

print(data_batch_1[b'labels'][2])


# In[272]:

get_ipython().magic('matplotlib inline')


# In[276]:

image = np.reshape(mean[0],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(image)
pyplot.show()


# In[277]:

image = np.reshape(mean[1],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(image)
pyplot.show()


# In[278]:

image = np.reshape(mean[2],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(image)
pyplot.show()


# In[279]:

image = np.reshape(mean[3],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(image)
pyplot.show()


# In[280]:

image = np.reshape(mean[4],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(image)
pyplot.show()


# In[281]:

image = np.reshape(mean[5],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(image)
pyplot.show()


# In[282]:

image = np.reshape(mean[6],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(image)
pyplot.show()


# In[283]:

image = np.reshape(mean[7],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(image)
pyplot.show()


# In[284]:

image = np.reshape(mean[8],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(image)
pyplot.show()


# In[285]:

image = np.reshape(mean[9],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(image)
pyplot.show()


# ### 1b first 20 principal components

# In[316]:

im = np.reshape(mean[2],(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(im)
pyplot.show()



# In[317]:

data_by_labels = [] #storing the image by labels, the list would be in this structure: data_by_labels[labes][row number of image][image data array]
for i in range (0,10):
    data_by_labels.append(np.zeros((int(count[i]), 3072)))


# In[318]:

len(data_by_labels[1])


# In[319]:

temp_count_loop = np.zeros(10) #for counting row number in each cateogry for the list for adding the image data to data_by_labels
print(temp_count_loop)


# In[320]:

print(data_by_labels[1][6])


# In[321]:

#move data from batch to data_by_labels so data is now by labels for PCA training
for i in range (0,5000):
    data_by_labels[data_batch_1[b'labels'][i]][int(temp_count_loop[data_batch_1[b'labels'][i]])] += data_batch_1[b'data'][i]
    temp_count_loop[data_batch_1[b'labels'][i]] += 1


# In[322]:

#fit pca on each labels
pca_objs = [PCA(20), PCA(20), PCA(20), PCA(20), PCA(20), PCA(20), PCA(20), PCA(20), PCA(20), PCA(20)]
for i in range(0,10):
    pca_objs[i].fit(data_by_labels[i])


# In[323]:

print(pca_objs)


# In[324]:

# apply pca on one image and show it 

apply_pca = pca_objs[7].transform(data_batch_1[b'data'][11])
apply_pca_2 = pca_objs[7].inverse_transform(apply_pca)


# In[267]:

apply_pca_3 = np.reshape(apply_pca_2,(3,32,32)).transpose(1,2,0).astype('uint8')
plt.imshow(apply_pca_3)
pyplot.show()


# In[271]:

#show the orgainl image and the category number
image = np.reshape(data_batch_1[b'data'][4],(3,32,32)).transpose(1,2,0).astype('uint8')
print(data_batch_1[b'labels'][4])
plt.imshow(image)
pyplot.show()


# In[268]:

print(pca_objs[1].explained_variance_)  


# the error is the amount of variation not explained by a principal component which will we equal to pc1 eigen value divided by sum of all the eigen values ???
# https://piazza.com/class/jchzguhsowz6n9?cid=489

# ### 2:  distances between mean image

# In[329]:

#euclidean_distances(np.reshape(mean[0],(3,1024)),np.reshape(mean[1],(3,1024)))
paired_distances(mean[1],mean[0])


# In[330]:

euc_dis = np.zeros((10,10))        
for i in range(0,10):
    for j in range(0,10):
        #euc_dis[i][j] = euclidean_distances(pca_objs[i].explained_variance_,pca_objs[j].explained_variance_)
        euc_dis[i][j] = euclidean_distances(mean[i],mean[j])


# In[331]:

print(euc_dis)


# In[332]:

mds = MDS(n_components=2, dissimilarity="precomputed", random_state=1)
pos = mds.fit_transform(euc_dis)
xs, ys = pos[:, 0], pos[:, 1]
for x, y, name in zip(xs, ys, labels):
    plt.scatter(x, y)
    plt.text(x, y, name)
plt.show()


# ### 3  average error obtained by PCA

# For class A and class B, define E(A | B) to be the average error obtained by representing all the images of class A using the mean of class A and the first 20 principal components of class B. Now define the similarity between classes to be (1/2)(E(A | B) + E(B | A)). If A and B are very similar, then this error should be small, because A's principal components should be good at representing B.

# In[ ]:



