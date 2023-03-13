import os
from argparse import ArgumentParser

import numpy as np


def parseArgs():
    argparser = ArgumentParser()
    argparser.add_argument(
        "-s",
        default=0,
        type=int,
        help="Seed for random number generator (default: 0)",
    )
    argparser.add_argument(
        "-N",
        default=10,
        type=int,
        help="Number of people (default: 10)",
    )
    argparser.add_argument(
        "-C",
        default=2,
        type=int,
        help="Number of clubs (default: 2)",
    )
    argparser.add_argument(
        "-p",
        default=0.1,
        type=float,
        help="Probability of friendship between two people (default: 0.1)",
    )
    argparser.add_argument(
        "-q",
        default=0.4,
        type=float,
        help="Probability of a person belonging to a club (default: 0.4)",
    )
    argparser.add_argument(
        "-o",
        default="data",
        type=str,
        help="Output directory for data files (default: data)",
    )
    argparser.add_argument(
        "-A",
        default="A.npy",
        type=str,
        help="Output file name for initial adjacency matrix (default: A.npy)",
    )
    argparser.add_argument(
        "-B",
        default="B.npy",
        type=str,
        help="Output file name for initial club membership matrix (default: B.npy)",
    )
    args = argparser.parse_args()
    assert args.N > 0, "N must be positive integer"
    assert args.C > 0, "C must be positive integer"
    assert 0 <= args.p <= 1, "p must be in [0, 1]"
    assert 0 <= args.q <= 1, "q must be in [0, 1]"
    if not os.path.exists(args.o):
        os.makedirs(args.o)
    return args


def main():
    args = parseArgs()
    np.random.seed(args.s)
    A = np.random.choice(
        (0, 1), (args.N, args.N), p=(1 - args.p / 2, args.p / 2), replace=True
    ).astype(np.int8)
    A += A.T
    A *= 1 - np.eye(args.N, dtype=np.int8)
    B = np.random.choice(
        (0, 1), (args.N, args.C), p=(1 - args.q, args.q), replace=True
    ).astype(np.int8)
    np.save(os.path.join(args.o, args.A), A, allow_pickle=False)
    np.save(os.path.join(args.o, args.B), B, allow_pickle=False)


if __name__ == "__main__":
    main()
