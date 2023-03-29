#import "template.typ": *
#set math.equation(numbering: "(1)")


// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "博弈论第一次作业",
  authors: (
    (name: "TeddyHuang-00", email: "teddyhuangnan@gmail.com", phone: "xxx-xxxx-xxxx"),
  ),
  date: "March 27, 2023",
)

// We generated the example code below so you can see how
// your document will look. Go ahead and replace it with
// your own content!

= 解答

以下为教材 6.11 中的部分题目解答，段落标题为对应题号。

== 1

*断言*：在二人博弈中，假设 A 有一个占优策略 $S_A$，则存在一个纯策略的纳什均衡，其中参与人 A 采取策略 $S_A$，参与人 B 采取对 $S_A$ 的一个最佳应对策略 $S_B$

此断言正确，一个直观证明如下：

$S_A = arg max_(S_A^* in cal(S)_A) V_A(S_A^* | S_B^*)$ 对于 $forall S_B^* in cal(S)_B$ 均成立，因此 A 一定选择 $S_A$ 作为自己的策略。

易证必存在 $S_B = arg max_(S_B^* in cal(S)_B) V_B(S_B^* | S_A)$，则构成一个纳什均衡，即有：
$ forall S_B^* in cal(S)_B, V_A(S_A | S_B) >= V_A(S_A^* | S_B) $
$ forall S_A^* in cal(S)_A, V_B(S_B | S_A) >= V_B(S_B^* | S_A) $

== 2

*陈述*：在二人博弈的纳什均衡中，每个参与人都选择了一个最优策略，所以两个参与人的策略是社会最优。

此陈述不正确，一个简单的反例如下：

以下为一个 A 和 B 二人博弈的矩阵，每个 $(x,y)$ 表示若 A 采取该行策略 $S_A$ 以及 B 采取该列策略 $S_B$ 的情况下 A 和 B 各自的收益。

#align(
  center,
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [], [$S_B^((1))$], [$S_B^((2))$],
    $S_A^((1))$,
    $(2, 2)$,
    $(0, 3)$,
    $S_A^((2))$,
    $(3, 0)$,
    $(1, 1)$
  )
)

在上述这个例子中，$(S_A^((2)),S_B^((2)))$ 构成一个纳什均衡，此时任意一方单独的改变策略均会使得自己的收益减小。这与社会最优的策略 $(S_A^((1)),S_B^((1)))$ 是不一致的。

== 5

对于给定的二人博弈：

#align(
  center,
  table(
    columns: (auto, auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [], [$L$], [$M$], [$R$],
    $U$, [1, 1], [2, 3], [1, 6],
    $M$, [3, 4], [5, 5], [2, 2],
    $D$, [1, 10], [4, 7], [0, 4],
  )
)

只需求出对 A 的局部最优策略组 $ pi_A^ast = {(arg max_(S_A){V_A(S_A|S_B)}, S_B) | forall S_B in cal(S)_B} $ 和对 B 的局部最优策略组 $ pi_B^ast = {(S_A, arg max_(S_B){V_B(S_B|S_A)}) | forall S_A in cal(S)_A} $ 则易证纳什均衡的策略组为 $ pi^ast = pi_A^ast union pi_B^ast $ <Nashi>

遵循此思路，求得：
$ pi_A^ast = { (M,L), (M,M), (M,R) } $
$ pi_B^ast = { (U,R), (M,M), (D,L) } $
$ => pi^ast = pi_A^ast union pi_B^ast = {(M,M)} $

因此只有 $(M,M)$ 构成纯策略纳什均衡。

== 6

=== a

对如下描述的收益矩阵，找出该博弈中所有纯策略纳什均衡：

#align(
  center,
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [], $L$, $R$,
    $U$, [2, 15], [4, 20],
    $D$, [6, 6], [10, 8]
  )
)

根据 @Nashi 的推论可得：
$ pi^ast = & pi_A^ast union pi_B^ast \
         = & { (D,L), (D,R) } union { (U,R), (D,R) } \
         = & {(D,R)} $

=== b

对如下描述的收益矩阵，找出该博弈中所有纯策略纳什均衡：

#align(
  center,
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [], $L$, $R$,
    $U$, [3, 5], [4, 3],
    $D$, [2, 1], [1, 6]
  )
)

根据 @Nashi 的推论可得：
$ pi^ast = & pi_A^ast union pi_B^ast \
         = & { (U,L), (U,R) } union { (U,L), (D,R) } \
         = & {(U,L)} $

=== c

对如下描述的收益矩阵，找出该博弈中所有纳什均衡：

#align(
  center,
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [], $L$, $R$,
    $U$, [1, 1], [4, 2],
    $D$, [3, 3], [2, 2]
  )
)

根据 @Nashi 的推论可得纯策略均衡：
$ pi^ast = & pi_A^ast union pi_B^ast \
         = & { (D,L), (U,R) } union { (U,R), (D,L) } \
         = & {(D,L), (U,R)} $

对于混合策略均衡，假设 $p:=P(S_A=U), q:=P(S_B=L)$，则应满足：
$
V_A(U) = & V_A(D) \
=> 1 times q + 4 times (1-q) = & 3 times q + 2 times (1-q) \
=> q = & 1/2
$
$
V_B(L) = & V_B(R) \
=> 1 times p + 3 times (1-p) = & 2 times p + 2 times (1-p) \
=> p = & 1/2
$
则 $(0.5, 0.5)$ 为混合策略纳什均衡

== 9

试找出如下二人博弈的所有纳什均衡

=== a

#align(
  center,
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [], $L$, $R$,
    $U$, [8, 4], [5, 5],
    $D$, [3, 3], [4, 8]
  )
)

==== 纯策略解

根据 @Nashi 的推论可得纯策略均衡：
$ pi^ast = & pi_A^ast union pi_B^ast \
         = & { (U,L), (U,R) } union { (U,R), (D,R) } \
         = & {(U,R)} $

==== 混合策略

由于 A 存在最优策略 $U$，因此不存在混合策略均衡

=== b

#align(
  center,
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    [], $L$, $R$,
    $U$, [0, 0], [-1, 1],
    $D$, [-1, 1], [2, -2]
  )
)

==== 纯策略解

根据 @Nashi 的推论可得纯策略均衡：
$ pi^ast = & pi_A^ast union pi_B^ast \
         = & { (U,L), (D,R) } union { (U,R), (D,L) } \
         = & nothing $

因此不存在纯策略均衡

==== 混合策略

对于混合策略均衡，假设 $p:=P(S_A=U), q:=P(S_B=L)$，则应满足：
$
V_A(U) = & V_A(D) \
=> 0 times q - 1 times (1-q) = & -1 times q + 2 times (1-q) \
=> q = & 3/4
$
$
V_B(L) = & V_B(R) \
=> 0 times p + 1 times (1-p) = & 1 times p - 2 times (1-p) \
=> p = & 3/4
$
则 $(0.75, 0.75)$ 为混合策略纳什均衡

== 13

考虑一个三人 (A, B, C) 博弈，决策空间分别为
$
cal(S)_A = & {U,D} \
cal(S)_B = & {L,R} \
cal(S)_C = & {l,r}
$

收益矩阵为

#align(
  center,
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    $S_C = l$, $L$, $R$,
    $U$, [4, 4, 4], [0, 0, 1],
    $D$, [0, 2, 1], [2, 1, 0]
  )
)

#align(
  center,
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    $S_C = r$, $L$, $R$,
    $U$, [2, 0, 0], [1, 1, 1],
    $D$, [1, 1, 1], [2, 2, 2]
  )
)

=== a

假设各参与人同时行动，则纯策略纳什均衡应满足 @Nashi 的推广，即：
$
pi^ast = & pi_A^ast union pi_B^ast union pi_C^ast \
       = & { (U,L,l), (U,L,r), (D,R,l), (D,R,r) } \
         & union { (U,L,l), (U,R,r), (D,L,l), (D,R,r) } \
         & union { (U,L,l), (U,R,l), (U,R,r), (D,L,l), (D,L,r), (D,R,r) } \
       = & { (U,L,l), (D,R,r) }
$

=== b

若 C 先选择策略，则即对应情况下 A 和 B 的二人博弈纯策略均衡分别为 $pi_l^ast,pi_r^ast$，则有
$
pi_l^ast = & pi_(A;l)^ast union pi_(B;l)^ast \
         = & { (U, L), (D, R) } union { (U, L), (D, L) } \
         = & { (U, L) }
$
$
pi_r^ast = & pi_(A;r)^ast union pi_(B;r)^ast \
         = & { (U, L), (D, R) } union { (U, R), (D, R) } \
         = & { (D, R) }
$
进一步将上述情况的均衡策略组拓展为三人博弈的策略组，则为
$
pi'_l = & { (U, L, l) } \
pi'_r = & { (D, R, r) }
$
则对于 C 而言，应当采取的策略组为
$
S = & arg max_(S^* in pi'_l union pi'_r){V_C(S^*)} \
  = & (U, L, l)
$
因此最终得到的策略组为 $(U,L,l)$，它是同时行为博弈的纳什均衡解之一。

== 思考

如果考虑二人博弈混合策略中，双方都能够根据对方的决策实时调整自己的决策，使自己的收益朝增大方向变化，则可以得到一个常微分方程系统。该系统的不动点可以认为是该条件下的一种解。以下为作业题目中所涉及到的一些二人博弈的结果对比。具体实现与视频演示#link("https://github.com/TeddyHuang-00/Computational-Thinking-in-Social-Sciences/tree/game-theory-ODE")[见此 GitHub 仓库]。流线图颜色表示二人收益总和（黄高紫低），即代表社会收益。

#figure(
  image("6-31.png", width: 60%),
  caption: [
    图 6-31，题 6(a) 对应的博弈 \
    系统最终收敛至 $(0,0)$，退化为纯策略均衡，与求得的 $(D,R)$ 解对应
  ],
)

#figure(
  image("6-32.png", width: 60%),
  caption: [
    图 6-32，题 6(b) 对应的博弈 \
    系统最终收敛至 $(0,1)$，退化为纯策略均衡，与求得的 $(D,L)$ 解对应
  ],
)

#figure(
  image("6-33.png", width: 60%),
  caption: [
    图 6-33，题 6(c) 对应的博弈 \
    系统会收敛至 $(0,1)$ 和 $(1,0)$，退化为纯策略均衡，与求得的 $(D,L),(U,R)$ 解对应 \
    此外还存在一个不稳定的鞍点不动点 $(1/2,1/2)$，为混合策略均衡解
  ],
)

#figure(
  image("6-37.png", width: 60%),
  caption: [
    图 6-37，题 9(a) 对应的博弈 \
    系统最终收敛至 $(1,0)$，退化为纯策略均衡，与求得的 $(U,R)$ 解对应
  ],
)

#figure(
  image("6-38.png", width: 60%),
  caption: [
    图 6-38，题 9(b) 对应的博弈 \
    系统之存在一个稳定的不动点 $(3/4,3/4)$，为混合策略均衡解
  ],
)