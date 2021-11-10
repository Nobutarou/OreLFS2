# Arch 向け kernel build config

## initramfs を不要にするために

```
# ルートファイルシステムは組み込み
CONFIG_XFS_FS=y

# initram 使わないんだから不要
# CONFIG_RD_GZIP is not set
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_RD_ZSTD is not set
```

## モジュールフォルダを上書きしないために

```
# 適当に ore1, ore2 などとしていけば、何かあってもすぐに戻れる。
# bzimage を /boot にコピーする名前ももちろん変える。
CONFIG_LOCALVERSION="ore"
```

## 小さくビルドするために

とは言ってもパフォーマンスに影響しないようなものは気にしない。ディスクは十分あるから。
もともとモジュールのものは無理に外さない. build 時間なんて気にしないから。

### Processor type and features

```
# user data leak を防ぐためのオプションらしいけど、多分それができる状況であるなら (PC 盗ま
# れたとか)、その時点で終ってる。
# CONFIG_RETPOLINE is not set

# /proc/<pid>/wchan が何か知らないけどパフォーマンスに影響があるらしいので
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set

# cpu family は分かりにくいけど Ryzen は Opteron のところで良いらしい。
# Gentoo wiki より
CONFIG_MK8=y 

# マルチコア用のスケジューラ。スケジューリングは改善するけど、これ自身パフォーマンス
# への影響があるみたい。
# CONFIG_SCHED_MC is not set

# intel の機能は一切不要
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_IOSF_MBI=m
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_X86_SGX is not set

# 自分の PC のためのカーネルなので不要
# CONFIG_HYPERVISOR_GUEST is not set

# ペタバイトのメモリなんてどこで売ってるの？
# CONFIG_X86_5LEVEL is not set

# たぶんこの Lenovo は Numa じゃない。でも物理 2コアだから最大でも 2ノード。2^1=2 
# なので 1
CONFIG_NODES_SHIFT=1

# クラッシュしたカーネルのダンプができても自分は無力
# CONFIG_CRASH_DUMP is not set
```

### kernel hacking

```
# 開発者でもないし、デバッグ情報を読み解けるわけでもない
# CONFIG_DEBUG_KERNEL is not set

# kernel panic などになっても、何かキーを押すとメモリダンプできたりするそうだが
# できたところで自分には何もできない
# CONFIG_MAGIC_SYSRQ is not set

# 以下保留
# 何か gcc に関する警告が出たところで理解できない
# CONFIG_FRAME_WARN=0

# unsure なら n とヘルプが言ってるので
# CONFIG_PAGE_POISONING is not set

# メモリデバッグテストの一つだけど、何が出たところで何ができるわけでもなし
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_WX is not set
# CONFIG_KFENCE is not set

# カーネルの挙動を追跡できたところで、自分は無力
# CONFIG_FTRACE is not set
# CONFIG_STACKTRACE is not set

# raid のテストは自分には無意味
# CONFIG_ASYNC_RAID6_TEST is not set
```



<!-- vim: set tw=90 filetype=markdown : -->

