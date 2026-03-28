# カーネルパニックについて

LFS はカーネルを自分で作るので、どうしてもカーネルパニックは避けられない。ヒントになれば

# ルートドライブをマウントできない

```
VFS: Cannot open root device "sdd1" or unknown-block(0,0): error -6
Please append a correct "root=" boot option; here are available partitions:
```

みたいなやつ。何回確認しても /dev/sdd1 で間違いない。実は、この次の行にカーネルが認識した
ディスクのリストが出るのだけど sr0 しか出てなかった。ということでカーネルの何かが不足して
るんだけど、どうするのか、という話し。

ホスト OS で lspci でデバイス毎に使われているドライバーを調べて、カーネルコンフィグで有効にする。

```zsh
lspci -v
```

で、
```
	Kernel driver in use: sdhci-pci
```
みたいなのが出てくるので、この sdhci-pci などを make menuconfig の中で検索をかけていって有
効にしていけば良い.

```zsh
make defconfig
```
で、現行のシステムを考慮してくれるということだったんだけど、全然だったな。


<!-- vim: set tw=90 filetype=markdown : -->

