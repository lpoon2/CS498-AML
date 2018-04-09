import numpy as np
import pandas as pd
from scipy.misc import logsumexp
from matplotlib import pyplot as plt
from scipy.stats import rankdata

D = 1500
W = 12419
N = 746316
n_blob = 30

#Covergence diff stopping condition
# https://piazza.com/class/jchzguhsowz6n9?cid=1218
stop_convergence_diff = 1e-4

def make_p_non_zero(p):
    for i in range(n_blob):
        non_zero_count = np.count_nonzero(p[i, :])
        zero_count = len(p[i, :]) - non_zero_count
        if zero_count == 0:
            continue
        add_p = float(0.05) / len(p[i, :])
        p[i, :] = np.multiply(p[i, :], 0.95)
        p[i, :] = np.add(p[i, :], add_p)
    return p

def e_step(dfcluster, w_ij, p, pi):
    for i in range(n_blob):
        p[i, :] = np.sum(dfcluster * w_ij[:, i].reshape(D, 1), axis=0) / np.sum(np.sum(dfcluster) * w_ij[:, i])
        pi[i] = np.sum(w_ij[:, i]) / D
    p = make_p_non_zero(p)
    return p, pi

def m_step(dfcluster, p, pi):
    k_sum = np.dot(dfcluster, np.transpose(np.log(p)))
    ij_sum = np.zeros((D, n_blob))
    for i in range(n_blob):
        ij_sum[:, i] = k_sum[:, i] + np.log(pi[i])

    maxrow = np.max(ij_sum, axis=1, keepdims=True)
    temp_ij_sum = ij_sum

    log_wij = np.zeros((D))
    for i in range(D):
        log_wij[i] = logsumexp(temp_ij_sum[i,] - maxrow[i])

    w_ij = np.zeros((D, n_blob))
    for i in range(n_blob):
        w_ij[:, i] = ij_sum[:, i] - maxrow.flatten() - log_wij.flatten()
    w_ij = np.exp(w_ij)

    Q = w_ij * ij_sum

    return Q, w_ij

def is_converged(prev_w_ij, w_ij, iteration):
    diff =  np.mean(np.abs(np.subtract(prev_w_ij, w_ij)))
    print str(iteration)+': diff w_ij='+str(diff)
    if diff <= stop_convergence_diff:
        return True
    else:
        return False

def main():
    dfcluster = np.zeros((D, W))
    dfcount = pd.read_table("docword.nips.txt", delimiter='\s+', header=None, skiprows=3)
    for row in dfcount.iterrows():
        dfcluster[row[1][0] - 1][row[1][1] - 1] = row[1][2]
    dfword = pd.read_table("vocab.nips.txt", delimiter='\s+', header=None)

    #Initialization
    blob_centers = dfcluster[np.random.choice(len(dfcluster), size=30, replace=False),:]
    p = np.zeros((n_blob, W))
    for i in range(n_blob):
        s = blob_centers[i]
        p[i, :] = s / sum(s)
    p = make_p_non_zero(p)
    pi = np.full(n_blob, 1/float(n_blob))

    iteration=1
    prev_w_ij = np.zeros((D, n_blob))
    while(True):
        Q, w_ij = m_step(dfcluster, p, pi)
        if is_converged(prev_w_ij, w_ij, iteration):
            break
        p, pi = e_step(dfcluster, w_ij, p, pi)
        iteration+=1
        prev_w_ij = w_ij

    for j in range(n_blob):
        print("====this is the data blob", j)
        for i in range(12419, 12409, -1):
            print(dfword.iloc[np.where((rankdata(p[j], method='ordinal')) == i)][0].values[0])

    a = pi
    N = len(a)
    b = range(N)
    width = 1 / 1.5
    plt.bar(b, a, width, color="blue")
    plt.savefig('7.1.png')

if __name__ == "__main__":
    main()