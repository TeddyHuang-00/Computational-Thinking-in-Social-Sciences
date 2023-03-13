# 网络演化

## 生成数据

### 课件中图示数据（固定数据）

```sh
python3 init_data.py
```

### 随机数据

```sh
usage: random_data.py [-h] [-s S] [-N N] [-C C] [-p P] [-q Q] [-o O] [-A A] [-B B]

options:
  -h, --help  show this help message and exit
  -s S        Seed for random number generator (default: 0)
  -N N        Number of people (default: 10)
  -C C        Number of clubs (default: 2)
  -p P        Probability of friendship between two people (default: 0.1)
  -q Q        Probability of a person belonging to a club (default: 0.4)
  -o O        Output directory for data files (default: data)
  -A A        Output file name for initial adjacency matrix (default: A.npy)
  -B B        Output file name for initial club membership matrix (default: B.npy)
```

例：生成共 100 个人，10 个社团，人与人之间的朋友关系的概率为 0.1，每个人参与各社团的概率为 0.1 的数据

```sh
python3 random_data.py -N 100 -C 10 -p 0.1 -q 0.1
```

## 运行模拟

```sh
usage: closure.py [-h] [-A A] [-B B] [-t T] [-s S] [-m M] [-o O] [-p P] [-d D] [-c]

options:
  -h, --help  show this help message and exit
  -A A        Numpy array file for initial adjacency matrix (default: data/A.npy)
  -B B        Numpy array file for initial club membership matrix (default: data/B.npy)
  -t T        Threshold for triadic closure (default: 3)
  -s S        Threshold for social focal closure (default: 2)
  -m M        Threshold for member closure (default: 2)
  -o O        Output directory for frames (default: frames)
  -p P        Output prefix for frames (default: frame-)
  -d D        DPI for frames (default: 600)
  -c          Clear output directory before running
```

## 生成视频

**你需要提前安装 ffmpeg 才可使用此脚本**

```sh
usage: post_process.py [-h] [-d D] [-i I] [-o O] [-f F] [-l]

options:
  -h, --help  show this help message and exit
  -d D        Input directory for frames (default: frames)
  -i I        Input file pattern for frames (default: frame-%d.png)
  -o O        Output file name for movie (default: video/movie.mp4)
  -f F        Frame rate for movie (default: 2)
  -l          Loop the movie
```
