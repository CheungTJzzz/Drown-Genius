# 6th work template by Liao
# 模块化编程

import timeit
import numpy as np
import matplotlib.pyplot as plt
import numba
from numba import njit

beta = 0.95
alpha = 1 / 3
delta=0.1
kss = (alpha * beta / (1-beta*(1-delta))) ** (1 / (1 - alpha))
kmin = 0.7 * kss
kmax = 1.3 * kss
n_k = 500
kgrid = np.linspace(kmin, kmax, n_k)
zgrid = np.array([0.9792, 0.9896, 1.0000, 1.0106, 1.0212])
P=np.array([
    [0.9727,0.0273,0,0,0],
    [0.0041,0.9806,0.0153,0,0],
    [0,0.0082,0.9836,0.0082,0],
    [0,0,0.0153,0.9806,0.0041],
    [0,0,0,0.0273,0.9727]
])
n_z = len(zgrid)

V0 = np.zeros((n_k, n_z))

def u(c):
    if c > 0:
        return np.log(c)
    else:
        return -np.inf
def budget(k_next_index, k_index, z_index):
    if zgrid[z_index]*kgrid[k_index]**alpha - kgrid[k_next_index]+(1-delta)*kgrid[k_index]>0:
        return zgrid[z_index]*kgrid[k_index]**alpha - kgrid[k_next_index]+(1-delta)*kgrid[k_index]
def V_current(k_next_index, k_index, z_index, V_next):
    """objective value function to be maximized"""
    c = budget(k_next_index, k_index, z_index)
    EV = np.sum(P[z_index]*V_next[k_next_index,:]) # expectation
    res = u(c) + beta * EV
    return res
def V_max(k_index, z_index,k_start,V):
    V_max = -np.inf
    for j in range(k_start,n_k):
        k_next = kgrid[j]
        V_new=V_current(j,k_index,z_index,V)
        if V_new > V_max:
            V_max = V_new
            g_k = k_next
            k_start = j
        else:break
    return V_max, g_k, k_start

def V_update(V):
    V_new = np.zeros((n_k, n_z))
    g_new = np.zeros((n_k, n_z))
    for i_z in range(n_z): # loop over all state z
        k_start = 0
        for i_k in range(k_start,n_k): # loop over all state k
            V_new[i_k, i_z], g_new[i_k, i_z] ,k_start= V_max(i_k, i_z,k_start,V)
    return V_new, g_new
def V_iteration(V_initial,tol):
    V = V_initial
    error = np.inf
    count = 0
    max_iter = 1000
    print_skip = 50
    while count < max_iter and error > tol:
        V_new, g_new = V_update(V)
        error = np.max(np.abs(V_new - V))
        V = V_new
        count = count + 1
        if count % print_skip == 0:
            print(f"Error at iteration {count} is {error}.")
    if error > tol:
        print("Failed to converge!")
    else:
        print(f"\nConverged in {count} iterations.")
    return V_new, g_new

start_time = timeit.default_timer()
V, g = V_iteration(V0,tol=1e-7)
print("The time difference is :", timeit.default_timer() - start_time)


for i in range (5):
    plt.plot(kgrid,g[:,i],label='z='+ str(zgrid[i]))
plt.plot(kgrid,kgrid,label="45 degree")
plt.xlabel("$k_t$")
plt.ylabel("$k_{t+1}$")
plt.title('$g(k_t)$')
plt.legend()


# satble distribution
def transQ(g):
    n_k, n_z = g.shape
    n = n_k * n_z
    Q = np.zeros(n, n)
    for j in numba.prange(n):
        i_k = j // n_z
        i_z = j % n_z
        diff = np.abs(g[i_k, i_z] - kgrid)
        mark = np.argmin(diff)
        j_prime_start = mark * n_z
        j_prime_end = j_prime_start + n_z
        Q[j, j_prime_start:j_prime_end] = P[i_z, :]
    return Q

Q=transQ(g)

from scipy.sparse.linalg import eigs
def stationary_distribution(transition_matrix):
    eigenvectors = eigs(transition_matrix.T,k=1,sigma=1)[1] #sigma指定特征根
    stationary_vector = np.abs(np.real(eigenvectors))
    stationary_distribution = stationary_vector / np.sum(stationary_vector)
    return stationary_distribution.flatten()

sd=stationary_distribution(Q)

def capital_marginal(joint_dist):
    tmp = joint_dist.reshape((n_k, n_z))
    k_marginal = tmp.sum(axis=1)
    return k_marginal

k_marginal=capital_marginal(sd)

plt.plot(kgrid,abs(k_marginal))
plt.xlabel("density")
plt.ylabel("k")
plt.title('marginal distribution of k')