import os
from argparse import ArgumentParser


def parseArgs():
    argparser = ArgumentParser()
    argparser.add_argument(
        "-d",
        default="frames",
        type=str,
        help="Input directory for frames (default: frames)",
    )
    argparser.add_argument(
        "-i",
        default="frame-%d.png",
        type=str,
        help="Input file pattern for frames (default: frame-%%d.png)",
    )
    argparser.add_argument(
        "-o",
        default="video/movie.mp4",
        type=str,
        help="Output file name for movie (default: video/movie.mp4)",
    )
    argparser.add_argument(
        "-f",
        default=2,
        type=int,
        help="Frame rate for movie (default: 2)",
    )
    argparser.add_argument(
        "-l",
        action="store_true",
        help="Loop the movie",
    )

    args = argparser.parse_args()
    assert os.path.exists(args.d), "Input directory does not exist"
    if not os.path.exists(os.path.dirname(args.o)):
        os.makedirs(os.path.dirname(args.o))
    return args


def main():
    args = parseArgs()
    os.system(
        f"ffmpeg -framerate {args.f} -i {os.path.join(args.d, args.i)} {'-loop 1' if args.l else ''} -c:v libx264 -profile:v high -crf 20 -pix_fmt yuv420p {args.o}"
    )


if __name__ == "__main__":
    main()
