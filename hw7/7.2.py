import scipy
import numpy as np
from scipy.misc import logsumexp
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

#Covergence diff stopping condition
# https://piazza.com/class/jchzguhsowz6n9?cid=1218
stop_convergence_diff = 1e-7

def is_converged(prev_w_ij, w_ij, iteration):
    diff =  np.mean(np.abs(np.subtract(prev_w_ij, w_ij)))
    print str(iteration)+': diff w_ij='+str(diff)
    if diff <= stop_convergence_diff:
        return True
    else:
        return False

def run_em(input_filename, output_filename, n_blob, random_state):
    print '\nRun KMeans and EM with ' + input_filename
    im = scipy.misc.imread(input_filename)
    red = im[:, :, 0]
    green = im[:, :, 1]
    blue = im[:, :, 2]
    samples = np.column_stack([red.flatten(), green.flatten(), blue.flatten()])
    output = np.zeros((im.size / 3, 3))

    # Initialization
    kmeans = KMeans(n_clusters=n_blob, random_state=random_state).fit(samples)
    kmeans_cluster = kmeans.cluster_centers_

    # Mean
    mu = np.hstack((kmeans_cluster[:, 0], kmeans_cluster[:, 1], kmeans_cluster[:, 2])).ravel()

    # Pi
    pi = np.full(kmeans_cluster.size, 1 / float(kmeans_cluster.size))

    # Image in RGB
    im1a_red = im[:, :, 0].astype(np.float64).flatten()
    im1a_green = im[:, :, 1].astype(np.float64).flatten()
    im1a_blue = im[:, :, 2].astype(np.float64).flatten()

    iteration = 1
    prev_w_ij = np.zeros((im.size / 3, 3 * n_blob))
    while True:
        ij_sum = np.zeros((im.size / 3, 3 * n_blob))
        for i in range(3 * n_blob):
            if i < n_blob:
                im1a = im1a_red
            elif i >= n_blob and i < 2 * n_blob:
                im1a = im1a_green
            elif i >= 2 * n_blob and i < 3 * n_blob:
                im1a = im1a_blue
            dis = im1a - mu[i]
            ij_sum[:, i] = np.multiply(np.multiply(dis, dis), -0.5)
        log_wij = np.dot(np.exp(ij_sum), np.diag(pi))
        w_ij = log_wij[:] / np.sum(log_wij[:], axis=0)

        for i in range(3 * n_blob):
            if i < n_blob:
                im1a = im1a_red
            elif i >= n_blob and i < 2 * n_blob:
                im1a = im1a_green
            elif i >= 2 * n_blob and i < 3 * n_blob:
                im1a = im1a_blue
            mu[i] = np.sum(im1a * w_ij[:, i]) / np.sum(w_ij[:, i])  # get p
            pi[i] = np.sum(w_ij[:, i]) / im1a.size  # get pi
        pi = pi + .000000000001  # get a small constant for pi so it doesnt get to 0
        pi[:] = pi[:] / sum(pi[:])

        if is_converged(prev_w_ij, w_ij, iteration):
            break
        iteration += 1
        prev_w_ij = w_ij

    mu = np.around(mu)
    mu_split = np.split(mu, 3)
    for i in range(im1a.size):
        output[i, 0] = min(mu_split[0], key=lambda x: abs(x - im1a_red[i]))
        output[i, 1] = min(mu_split[1], key=lambda x: abs(x - im1a_green[i]))
        output[i, 2] = min(mu_split[2], key=lambda x: abs(x - im1a_blue[i]))

    outputim = np.zeros((im.shape[0], im.shape[1], 3))
    for j in range(3):
        outputim[:, :, j] = output[:, j].reshape((im.shape[0], im.shape[1]))
    plt.imshow(outputim.astype(np.uint8))
    plt.savefig(output_filename)
    plt.clf()
    print 'Saved ' + output_filename

def main():
    # Segment each test images to 10, 20, 50 with random state 1
    run_em('RobertMixed03.jpg', 'RobertMixed03.10segments.png', 10, 1)
    run_em('RobertMixed03.jpg', 'RobertMixed03.20segments.png', 20, 1)
    run_em('RobertMixed03.jpg', 'RobertMixed03.50segments.png', 50, 1)
    run_em('smallstrelitzia.jpg', 'smallstrelitzia.10segments.png', 10, 1)
    run_em('smallstrelitzia.jpg', 'smallstrelitzia.20segments.png', 20, 1)
    run_em('smallstrelitzia.jpg', 'smallstrelitzia.50segments.png', 50, 1)
    run_em('smallsunset.jpg', 'smallsunset.10segments.png', 10, 1)
    run_em('smallsunset.jpg', 'smallsunset.20segments.png', 20, 1)
    run_em('smallsunset.jpg', 'smallsunset.50segments.png', 50, 1)

    # Segment test image (using 20 segments using five different start points
    # test image is smallsunset.jpg. See https://piazza.com/class/jchzguhsowz6n9?cid=1157
    # use different starting point by using different random state: See https://piazza.com/class/jchzguhsowz6n9?cid=1230
    run_em('smallsunset.jpg', 'smallsunset.20segments.randomstate2.png', 20, 2)
    run_em('smallsunset.jpg', 'smallsunset.20segments.randomstate3.png', 20, 3)
    run_em('smallsunset.jpg', 'smallsunset.20segments.randomstate4.png', 20, 4)
    run_em('smallsunset.jpg', 'smallsunset.20segments.randomstate5.png', 20, 5)
    run_em('smallsunset.jpg', 'smallsunset.20segments.randomstate6.png', 20, 6)

if __name__ == "__main__":
    main()