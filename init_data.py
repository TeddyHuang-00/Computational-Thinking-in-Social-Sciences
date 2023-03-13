import os

import numpy as np

if not os.path.exists("data"):
    os.makedirs("data")

NUM_PEOPLE = 10
NUM_CLUB = 2


def add_edge(A: np.ndarray, i: int | list[int], j: int | list[int]):
    A[i, j] = 1
    A[j, i] = 1


A = np.zeros((NUM_PEOPLE, NUM_PEOPLE), dtype=np.int8)
add_edge(
    A,
    [0, 0, 3, 3, 5, 5, 6, 6, 7, 8],
    [1, 3, 5, 6, 7, 9, 7, 9, 8, 9],
)
np.save("data/A.npy", A, allow_pickle=False)


B = np.zeros((NUM_PEOPLE, NUM_CLUB), dtype=np.int8)
B[[0, 1, 5], 0] = 1
B[[1, 2, 3, 4], 1] = 1
np.save("data/B.npy", B, allow_pickle=False)
