import logging
import os
import shutil
from argparse import ArgumentParser
from collections import defaultdict

import networkx as nx
import numpy as np
from matplotlib import pyplot as plt
from rich.logging import RichHandler

logging.basicConfig(
    level="INFO",
    format="%(message)s",
    datefmt="[%X]",
    handlers=[RichHandler(rich_tracebacks=True)],
)
LOGGER = logging.getLogger(__name__)


def homogenity(A: np.ndarray, B: np.ndarray):
    # Count all different types of nodes
    props: defaultdict[tuple, int] = defaultdict(int)
    for b in B:
        props[tuple(b)] += 1
    # Calculate probability of heterogenous edges
    prob = 0.0
    for i, p in enumerate(list(props.values())[:-1]):
        for q in list(props.values())[i + 1 :]:
            prob += p * q
    prob *= 2.0
    prob /= len(A) ** 2
    # Count heterogenous edges and divide by total number of edges
    freq = 0.0
    for i, j in zip(*np.where((A > 0) & np.triu(np.ones_like(A, dtype=bool), k=1))):
        if not np.array_equal(B[i], B[j]):
            freq += 1
    freq /= np.sum(A * np.triu(np.ones_like(A, dtype=bool), k=1))
    return freq, prob


def visualize(
    timestep: int,
    A: np.ndarray,
    B: np.ndarray,
    new_friend: np.ndarray | None = None,
    new_member: np.ndarray | None = None,
    output_dir: str = ".",
    output_prefix: str = "closure-",
    dpi: int = 600,
):
    G: nx.Graph = nx.from_numpy_array(A)
    # Add club nodes
    for i in range(B.shape[1]):
        G.add_node(f"C {i+1}", shape="box")
    # Add links to club nodes
    for i, c in enumerate(B):
        for j, b in enumerate(c):
            if b:
                G.add_edge(i, f"C {j+1}")
    # Get Fixed position of nodes
    pos = nx.circular_layout(G)
    # Draw club nodes with different shape
    nx.draw_networkx_nodes(
        G,
        pos,
        nodelist=[f"C {j+1}" for j in range(B.shape[1])],
        node_shape=",",
        node_color="tab:orange",
        node_size=600,
    )
    # Draw other nodes
    nx.draw_networkx_nodes(
        G, pos, nodelist=np.arange(len(A)), node_size=450, node_color="tab:blue"
    )
    # Draw all edges
    nx.draw_networkx_edges(G, pos)
    # Highlight newly added edges
    if new_friend is not None:
        nx.draw_networkx_edges(G, pos, edgelist=new_friend, edge_color="tab:red")
    if new_member is not None:
        nx.draw_networkx_edges(
            G,
            pos,
            edgelist=[(i, f"C {c+1}") for i, c in new_member],
            edge_color="tab:green",
        )
    # Draw labels
    nx.draw_networkx_labels(G, pos)
    # Calculate metrics
    freq, prob = homogenity(A, B)
    plt.title(
        f"Time step {timestep:d}, heterogenity ${freq:.03f}$ (obs) vs ${prob:.03f}$ (exp)"
    )
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, f"{output_prefix}{timestep:d}.png"), dpi=dpi)
    plt.close()


def evolve(A: np.ndarray, B: np.ndarray, t: int, s: int, m: int):
    # Calculate triadic, social focal and member closure
    T = A @ A.T
    S = B @ B.T
    M = A @ B
    triadic = np.where((A == 0) & (T >= t) & np.triu(np.ones_like(A, dtype=bool), k=1))
    social = np.where((A == 0) & (S >= s) & np.triu(np.ones_like(A, dtype=bool), k=1))
    member = np.where((B == 0) & (M >= m))
    # Reshape edge list and remove duplicates
    new_friend = np.array(list(set(zip(*triadic)) | set(zip(*social))))
    new_member = np.array(list(set(zip(*member))))
    # Add new edges to graph
    if len(new_friend):
        A[new_friend[:, 0], new_friend[:, 1]] = 1
        A[new_friend[:, 1], new_friend[:, 0]] = 1
    if len(new_member):
        B[new_member[:, 0], new_member[:, 1]] = 1
    return new_friend, new_member


def parseArgs():
    # Create argument parser
    argparser = ArgumentParser()
    argparser.add_argument(
        "-A",
        default="data/A.npy",
        type=str,
        help="Numpy array file for initial adjacency matrix (default: data/A.npy)",
    )
    argparser.add_argument(
        "-B",
        default="data/B.npy",
        type=str,
        help="Numpy array file for initial club membership matrix (default: data/B.npy)",
    )
    argparser.add_argument(
        "-t",
        default=3,
        type=int,
        help="Threshold for triadic closure (default: 3)",
    )
    argparser.add_argument(
        "-s",
        default=2,
        type=int,
        help="Threshold for social focal closure (default: 2)",
    )
    argparser.add_argument(
        "-m",
        default=2,
        type=int,
        help="Threshold for member closure (default: 2)",
    )
    argparser.add_argument(
        "-o",
        default="frames",
        type=str,
        help="Output directory for frames (default: frames)",
    )
    argparser.add_argument(
        "-p",
        default="frame-",
        type=str,
        help="Output prefix for frames (default: frame-)",
    )
    argparser.add_argument(
        "-d",
        default=600,
        type=int,
        help="DPI for frames (default: 600)",
    )
    argparser.add_argument(
        "-c",
        action="store_true",
        help="Clear output directory before running",
    )
    # Parse args and check for errors
    args = argparser.parse_args()
    assert os.path.exists(args.A), f"File {args.A} does not exist"
    assert os.path.exists(args.B), f"File {args.B} does not exist"
    assert args.t > 0, "Threshold for triadic closure must be positive integer"
    assert args.s > 0, "Threshold for social focal closure must be positive integer"
    assert args.m > 0, "Threshold for member closure must be positive integer"
    assert args.d > 0, "DPI must be positive"
    if not os.path.exists(args.o):
        LOGGER.info(f"Creating output directory {args.o}...")
        os.makedirs(args.o)
    elif args.c:
        LOGGER.info(f"Clearing output directory {args.o}...")
        shutil.rmtree(args.o)
        os.makedirs(args.o)
    return args


def main():
    args = parseArgs()
    A = np.load(args.A, allow_pickle=False)
    B = np.load(args.B, allow_pickle=False)
    frame = 0
    new_friend, new_member = None, None
    while True:
        LOGGER.info(f"Generating frame {frame:d}...")
        visualize(
            frame,
            A,
            B,
            new_friend,
            new_member,
            output_dir=args.o,
            output_prefix=args.p,
            dpi=args.d,
        )
        LOGGER.info(f"Calculating next time step...")
        new_friend, new_member = evolve(A, B, args.t, args.s, args.m)
        if len(new_friend) == 0 and len(new_member) == 0:
            LOGGER.info("No more new edges, exiting...")
            break
        frame += 1


if __name__ == "__main__":
    main()
