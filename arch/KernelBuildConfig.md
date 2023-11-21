# Arch 向け kernel build config

kernel-6.5.5 でそれまで作ってきた .config で動かなくなったので、やり直す。

## initramfs を不要にするために

<!--{{{-->

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

## モジュール

```
# モジュールフォルダを上書きしないように、名前を付ける
# 適当に ore1, ore2 などとしていけば、何かあってもすぐに戻れる。
# bzimage を /boot にコピーする名前ももちろん変える。
CONFIG_LOCALVERSION="ore"
```

```
# arch は y でビルドして strip するということをしている。始めから不要
# CONFIG_MODULE_SIG=n
```

```
# debug シンボルを消しながらインストールするのに。
# デバッグ関連のフラッグをへし折っていけば自然と不要になると思う。
make INSTALL_MOD_STRIP=1 modules_install
```
<!--}}}-->

## 不要な機能

### general

<!--{{{-->
```
# arch は no_hz_full を使うがカーネルパラメータに nohz_full を入れないと no_hz_idle と同じ
# と書いてある。じゃあ no_hz_idle でいいじゃん
CONFIG_NO_HZ_IDLE=y
#CONFIG_NO_HZ_FULL
```
<!--}}}-->

### mitigations

<!--{{{-->
```
# 個人に対してこれらの脆弱性を突ける時点で、既にセキュリティは突破されてる
# CONFIG_SPECULATION_MITIGATIONS
```
<!--}}}-->

### Library routines

<!--{{{-->
```
# CONFIG_CRC4 (6.5.9ore2)
# CONFIG_FONTS (6.5.9ore3)
```
<!--}}}-->

### Cryptographic API 今ここ

```
# Crypto core or helper
# CONFIG_CRYPTO_PCRYPT (6.5.9 ore4)
# CONFIG_CRYPTO_TEST (6.5.9 ore5)
# CONFIG_CRYPTO_ECRDSA (6.5.9 ore6)

### hacking
<!--{{{-->
どうせ何も分からないので、問題なければ無効にしていく。
やる前に Archwiki と GentooWiki で何かに使われていないかは調べる。

```
# これ無効にすると 
# make INSTALL_MOD_STRIP=1 modules_install の環境変数不要になる希ガス
#CONFIG_DEBUG_KERNEL

# 使えたことが無いからいらん
#CONFIG_MAGIC_SYSRQ

# memory debuggig 
# 基本デバッグなんか出来ないから全部外す方針。
# なんか使えなくなったり、パフォーマンスに影響あれば戻す。
# CONFIG_PAGE_POISONING
# CONFIG_DEBUG_WX 
# CONFIG_SHRINKER_DEBUG 
# CONFIG_KFENCE

# tracers
<!--{{{-->
# CONFIG_BOOTTIME_TRACING
# CONFIG_FUNCTION_GRAPH_TRACER 
# CONFIG_DYNAMIC_FTRACE
# CONFIG_FUNCTION_PROFILER (ore10)
# CONFIG_STACK_TRACER (ore11)
# CONFIG_FUNCTION_TRACER (ore12, kpatch というものに使うらしいが知らん)
# CONFIG_SCHED_TRACER (ore13)
# CONFIG_HWLAT_TRACER (ore14)
# CONFIG_TIMERLAT_TRACER (ore15)
# CONFIG_OSNOISE_TRACER (ore16)
# CONFIG_MMIOTRACE (ore17)
# CONFIG_FTRACE_SYSCALLS (ore18)
# CONFIG_TRACER_SNAPSHOT (ore19)
# CONFIG_BLK_DEV_IO_TRACE (ore20, powertop に使うらしいが知らん)
# CONFIG_KPROBE_EVENTS (ore21)
# CONFIG_UPROBE_EVENTS (ore22)
# CONFIG_USER_EVENTS (ore23)
# CONFIG_HIST_TRIGGERS (ore24)
<!--}}}-->

# debugging も printk to debug port は要らないだろう。手段もなにも無いし。

# test and coverage
# CONFIG_FUNCTION_ERROR_INJECTION (ore26)
# CONFIG_ASYNC_RAID6_TEST (ore27)
# CONFIG_MEMTEST (6.5.9ore1)
```
<!--}}}-->

## 必要

### hacking

```
# これが無いと rog gladius iii の bluetooth 接続時のバッテリー残量が見えない
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_SYNTH_EVENTS=y (ore25)
```

# 以下は古い情報
## 小さくビルドするために

とは言ってもパフォーマンスに影響しないようなものは気にしない。ディスクは十分あるから。
もともとモジュールのものは無理に外さない. build 時間なんて気にしないから。

### general

```

# 1st level
# desktop 向としておく。
CONFIG_PREEMPT_VOLUNTARY = y

## CPU/Task time and stats accounting
# unsure = n なのと performance impact あるらしいので
# CONFIG_IRQ_TIME_ACCOUNTING

# 1st level
# 良く分からないけど journal が起動すればカーネルがログ貯める必要なくない？
# 良く分からないけど jounalctl, dmesg で起動直後のが見えなくなったので
# あまり小さくしてはだめ。とりあえず arch 設定-1 にとどめておく
CONFIG_LOG_BUF_SHIFT = 16
CONFIG_LOG_CPU_MAX_BUF_SHIFT = 13
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT = 12

# performance impact が有るらしいので
# CONFIG_SLAB_FREELIST_HARDENED
```

### Processor type and features

```
# user data leak を防ぐためのオプションらしいけど、多分それができる状況であるなら (PC 盗ま
# れたとか)、その時点で終ってる。
# CONFIG_RETPOLINE is not set

# /proc/<pid>/wchan が何か知らないけどパフォーマンスに影響があるらしいので
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set

# cpu family は分かりにくいけど Ryzen は Opteron のところで良いらしい。
# Gentoo wiki より。-march=k8 が付く。
# なのだけど Phoronix でいくつかベンチしたけど -march 無しと差が出ないので
# generic で良い。
CONFIG_GENERIC_CPU=y

# マルチコア用のスケジューラ。スケジューリングは改善するけど、これ自身パフォーマンス
# への影響があるみたい。
# CONFIG_SCHED_MC is not set

# intel の機能は一切不要
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_IOSF_MBI=m
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_X86_SGX is not set

# dell で使わない
# CONFIG_I8K

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

### power management

```
# CONFIG_SUSPEND
# CONFIG_HIBERNATION
# CONFIG_PM_DEBUG

# 省電力不要
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT

## acpi support
# CONFIG_ACPI_EC_DEBUGFS
# 
# initrd を使ってなにかする機能だけど initrd 使わない
# CONFIG_ACPI_TABLE_UPGRADE
# CONFIG_ACPI_DEBUG
# CONFIG_ACPI_HOTPLUG_MEMORY

## cpu freq.
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
# CONFIG_X86_INTEL_PSTATE
# CONFIG_X86_P4_CLOCKMOD
# CONFIG_INTEL_IDLE

# back to 1st tree
```

### loadable modules support

```
# 得体の知れないモジュールを無理矢理ロードしなくて良い
# CONFIG_MODULE_FORCE_LOAD

# 使用中のモジュールを無理矢理アンロードしなくて良い
# CONFIG_MODULE_FORCE_UNLOAD

# メンテナがソースの正確なバージョンを知るのに有効らしいが、私には使いこなせない
# CONFIG_MODULE_SRCVERSION_ALL

# arch は y でビルドして strip するということをしている。始めから不要
# CONFIG_MODULE_SIG
```

### memory management options

```
# 物理的に稼働中の抜き差しはほぼ不可能
# MEMORY_HOTPLUG

# unsure = n
# CONFIG_CMA
```

### Networking Support

良く分からないので2階層までとする。
コメントしてないのは unsure=no や debug 目的であるもの

```
## networking options

# unsure = no
# CONFIG_TLS
# CONFIG_XFRM_INTERFACE
# CONFIG_XFRM_SUB_POLICY
# CONFIG_XFRM_STATISTICS
# CONFIG_NET_KEY_MIGRATE
# CONFIG_XFRM_MIGRATE
# CONFIG_IP_MULTICAST
# CONFIG_IP_ADVANCED_ROUTER
# CONFIG_NET_IPIP
# CONFIG_INET_ESP_OFFLOAD
# CONFIG_INET_ESPINTCP
# CONFIG_INET_DIAG_DESTROY
# CONFIG_TCP_CONG_ADVANCED
# CONFIG_TCP_MD5SIG

# 1st level

# アマチュア無線不要
# CONFIG_HAMRADIO

# シリアル通信による低速通信は必要ない
# CONFIG_CAN

## bluetooth subsystem
# CONFIG_BT_DEBUGFS

# back to 1st level
# CONFIG_AF_RXRPC_DEBUG

## wireless
# CONFIG_CFG80211_DEBUGFS
# CONFIG_MAC80211_DEBUGFS

# back to 1st level
# CONFIG_NET_9P
# CONFIG_CEPH_LIB

# おさいふ携帯で有名になったあの NFC は付いてない
# CONFIG_NFC
```

### Device drivers 第一階層

ここは第一階層で消せるものを消す。

```
# 付いてない, 付けることも無い
# CONFIG_PCCARD is not set

# GPS reciever は無い
# CONFIG_GNSS is not set

# parallel port などない
# CONFIG_PARPORT is not set

# RAID も論理パーティションかなにかも使いません
# CONFIG_MD is not set

# むしろアンチ
# CONFIG_MACINTOSH_DRIVERS is not set

# Open channel ssd 知りません。deprecated だそうです。要りません
# CONFIG_NVM is not set

# 障害があるときになにかする機能。自分はカーネル変えて再起動するだけだ
# CONFIG_WATCHDOG

# sony のメモリスティックなるものは無い
# CONFIG_MEMSTICK

# 無い
# CONFIG_INFINIBAND 
# CONFIG_CHROME_PLATFORMS
# CONFIG_SURFACE_PLATFORMS

# 物理のポストありません
# CONFIG_MAILBOX

# 仮想環境のゲストになることはない
# CONFIG_VIRT_DRIVERS
# VIRTIO_MENU
```

### Device Drivers, PCI support

```
# ノートpc を動いてるまま蓋開けて、pci に何か差したりしないし、たぶん空いてない
# CONFIG_HOTPLUG_PCI_PCIE

# エラーを報告されても活用する腕がない
# CONFIG_PCIEAER

# CONFIG_HOTPLUG_PCI
```

### device drivers, block devices

```
# floppy なんて存在しない
# CONFIG_BLK_DEV_FD

# カーネル組み込み暗号化は難しくて使いこなせない
# CONFIG_BLK_DEV_CRYPTOLOOP

# network block device 不要です
# CONFIG_BLK_DEV_NBD:

# インストールイメージを展開するときに役に立つ ram disk だそうです
# most normal users には不要だそうです。
# CONFIG_BLK_DEV_RAM

# packet writing on cd/dvd だそうで deprecated だそうです。
# CONFIG_CDROM_PKTCDVD

# wifi しかないノートです。
# CONFIG_ATA_OVER_ETH

# host にしか成り得ないカーネル
# CONFIG_VIRTIO_BLK

# unsure = n だそうです 
# CONFIG_BLK_DEV_RBD

```

### device drivers, scsi device support

ATA や CDR が昔は scsi 扱いだったので、いまだに切れないでいる。

```
# テープを使うことはない
# CONFIG_CHR_DEV_ST

# cd チェンジャーを今使う人は居ない
# CONFIG_CHR_DEV_SCH
# CONFIG_SCSI_ENCLOSURE

# エラーが出たとろでどうしようもない. デバッグログが出たところでどうしようもない
# CONFIG_SCSI_CONSTANTS
# CONFIG_SCSI_LOGGING
```

### device drivers, sata pata drivers

```
# 壊れたら買い替えるだけだ
# CONFIG_ATA_VERBOSE_ERROR
```

### device drivers, fireware support

fireware 無いから、この下全て不要

### device drivers, networks devices

```
# ethernet 用の機能なので何か知らないけど不要
# CONFIG_BONDING

# 2台の pc をシリアルで繋ぐことは無い、というかserial が無い
# CONFIG_EQUALIZER

# storage をなんかで繋ぐことは無い
# CONFIG_NET_FC

# virtual な device 不要
# CONFIG_NET_TEAM
# CONFIG_MACVLAN
# CONFIG_IPVLAN
# CONFIG_VXLAN
# CONFIG_GENEVE

# ethernet 向けの encryption
# CONFIG_MACSEC

# virtual
# NTB_NETDEV 

# これが何か分からん奴が使うことはないんだそうだ。ありがとう
# CONFIG_TUN

# virtual
# CONFIG_VETH

# CONFIG_VIRTIO_NET

# virtual
# CONFIG_NET_VRF

# wwan モデムのドライバー。知らんけど絶対に不要だろう
# CONFIG_MHI_NET

# ネットワーク越しにkernel マッサージを読むことなんて無い
# CONFIG_NETCONSOLE

# ネットワークを観察するデベロッパー向けの機能
# CONFIG_NLMON
# CONFIG_VSOCKMON

# atm はとにかく有線でのデバイスらしいので全く関係ない
# CONFIG_ATM_DRIVERS

# Distributed Switch Architecture drivers は ethernet のスイッチだから不要
# 下層全消し

# 全ての ethernet driver support. wifi しかない。

# 光ファイバーかなにかでしょう
# CONFIG_FDDI

# 知らない = 持ってない
# CONFIG_NET_SB1000:

# スイッチ
# MICREL_KS8995MA
# CONFIG_MDIO_DEVICE

# ethernet の何か
# CONFIG_PCS_XPCS

# モデムの仕事
# CONFIG_PPP
# CONFIG_SLIP

# wireless lan は atheros (ath10) だけ残す。ath でも debug は消す。
# CONFIG_ATH10K_DEBUG
# CONFIG_ATH10K_DEBUGFS
# developer's test
# CONFIG_MAC80211_HWSIM
# Wifi に偽装する ethernet
# CONFIG_VIRT_WIFI 

# wifi でも bluetooth でもない何かの無線通信
# CONFIG_IEEE802154_DRIVERS

# wireless wan 以下は全消し。wan じゃない、クライアントだ。

# vmware じゃなくて virtual box 使うと思う
# CONFIG_VMXNET3

# とにかく wifi, bluetooth 以外は無い
# CONFIG_FUJITSU_ES

# lenovo がそんなの付けるわけない
# CONFIG_USB4_NET

# developer test
# CONFIG_NETDEVSIM

# CONFIG_ISDN
```

### device drivers, input device support

```
# アップルやタッチキーなどのキーボードは買うことないだろう
# こういうのってなんで user space でやらずに、本体に組込むんだろう
# CONFIG_KEYBOARD_APPLESPI
# CONFIG_KEYBOARD_QT1050
# CONFIG_KEYBOARD_QT1070
# CONFIG_KEYBOARD_QT2160
# CONFIG_KEYBOARD_DLINK_DIR685
# CONFIG_KEYBOARD_MCS
# CONFIG_KEYBOARD_MPR121
# CONFIG_KEYBOARD_TM2_TOUCHKEY

# tablet は使わないだろう
# CONFIG_INPUT_TABLET

# touch screen も不要。PC では便利ではない
# CONFIG_INPUT_TOUCHSCREEN
```

### device drivers, character device

```
# CONFIG_VIRTIO_CONSOLE
```

### device drivers, graphic supports

```
# CONFIG_VGA_SWITCHEROO
# CONFIG_DRM_RADEON
# CONFIG_DRM_NOUVEAU
# CONFIG_DRM_I915

# test まはた headless マシンで使うものなので n
# CONFIG_DRM_VKMS

# CONFIG_DRM_VMWGFX
# CONFIG_DRM_GMA500
# CONFIG_DRM_MGAG200
# CONFIG_DRM_QXL
# CONFIG_DRM_BOCHS
# CONFIG_DRM_VIRTIO_GPU
# CONFIG_DRM_CIRRUS_QEMU
# CONFIG_DRM_GM12U320
# CONFIG_DRM_VBOXVIDEO
```

### device drivers, sound card support

```
# alsa 下

# 読みとる能力が無い
# CONFIG_SND_VERBOSE_PROCFS
# CONFIG_SND_VERBOSE_PRINTK
# CONFIG_SND_DEBUG

# CONFIG_SND_VIRTIO

# generic sound drivers

# テスターではない
# CONFIG_SND_DUMMY

# CONFIG_SND_VIRMIDI
# CONFIG_SND_AC97_POWER_SAVE

# HD-audio

# 迷惑
# CONFIG_SND_HDA_INPUT_BEEP

# MMC/SD/SDIO card support 

# CONFIG_MMC_TEST

# RTC debug support
# CONFIG_RTC_DEBUG
```

### device drivers, virtio immo

```
# CONFIG_VIRTIO_IOMMU
```

### device drivers, Rpmsg drivers
```
# RPMSG_VIRTIO
```

### device dirvers, RAS
```
# error を集めたところで使えない
# CONFIG_RAS_CEC
```

### file systems

```
# 使わなそうなファイルシステム
# CONFIG_REISERFS_FS
# CONFIG_JFS_FS
# CONFIG_GFS2_FS
# CONFIG_OCFS2_FS
# CONFIG_BTRFS_FS
# CONFIG_NILFS2_FS
# CONFIG_F2FS_FS
# CONFIG_ZONEFS_FS

# カーネル組み込み暗号化は基本使いにくい。gpg や gocryptfs なんかのほうが使い易い
# CONFIG_FS_ENCRYPTION

# unsure なら n だそうで。
# CONFIG_FS_VERITY

# 気にしたことがない。でかい SSD 買おう
# CONFIG_QUOTA

# 上を off にしたら自動で off になってくれないか？
# CONFIG_QUOTA_NETLINK_INTERFACE

# file system の下に file system を作る。必要性が分からない
# CONFIG_OVERLAY_FS

# overhead があり debug に有効ということなので、自分には無効
# CONFIG_NETFS_STATS
# CONFIG_FSCACHE_STATS

# debug purpose 不要
# CONFIG_FSCACHE_OBJECT_LIST

# 不要な fs
# CONFIG_ORANGEFS_FS
# CONFIG_AFFS_FS
# CONFIG_ECRYPT_FS
# CONFIG_HFS_FS
# CONFIG_HFSPLUS_FS
# CONFIG_BEFS_FS
# CONFIG_JFFS2_FS
# CONFIG_UBIFS_FS
# CONFIG_CRAMFS
# CONFIG_SQUASHFS
# CONFIG_MINIX_FS
# CONFIG_OMFS_FS
# CONFIG_ROMFS_FS
# CONFIG_VIRTIO_FS

# kernel panic を ram に書きだすそうだが、それを活用する方法を知らない
# CONFIG_PSTORE_RAM

# 不要な fs
# CONFIG_UFS_FS
# CONFIG_EROFS_FS

# virtual box guest 側の fs は不要
# CONFIG_VBOXSF_FS

# nas しない
# CONFIG_NETWORK_FILESYSTEMS

# debug 使いこなせない
# CONFIG_DLM_DEBUG

## native language support
# 不要な言語は全部消す
# apple 系も消す
CONFIG_NLS_CODEPAGE_437 = m
CONFIG_NLS_CODEPAGE_932 = m
CONFIG_NLS_ASCII = m
CONFIG_NLS_ISO8859_1 = m
CONFIG_NLS_UTF8 = m

```

### security options

基本的に自己責任。

```
# unsure なら n だそうだ。
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set

# dmesg が一般ユーザーで読めないのは、こいつのせいだった。
# CONFIG_SECURITY_DMESG_RESTRICT is not set

# 1~7% 程度パフォーマンスに影響が出るということで off
# いつでもブートオプションで有効にできる
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
```

### Cryptographic API

```
## Hardware crypto devices
# CONFIG_CRYPTO_DEV_PADLOCK
# CONFIG_CRYPTO_DEV_ATMEL_ECC
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS
# CONFIG_CRYPTO_DEV_QAT_DH895xCC
# CONFIG_CRYPTO_DEV_QAT_C3XXX
# CONFIG_CRYPTO_DEV_QAT_C62X
# CONFIG_CRYPTO_DEV_QAT_4XXX
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF
# CONFIG_CRYPTO_DEV_QAT_C3XXXVF
# CONFIG_CRYPTO_DEV_QAT_C62XVF
# CONFIG_CRYPTO_DEV_NITROX_CNN55XX
# CONFIG_CRYPTO_DEV_CHELSIO
# CONFIG_CRYPTO_DEV_VIRTIO
# CONFIG_CRYPTO_DEV_SAFEXCEL
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL
```

### kernel hacking

```
# 開発者でもないし、デバッグ情報を読み解けるわけでもない
# CONFIG_DEBUG_KERNEL is not set

## Generic Kernel Debugging Instruments
# kernel panic などになっても、何かキーを押すとメモリダンプできたりするそうだが
# できたところで自分には何もできない
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_DEBUG_FS

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

## x86 debuging tree
# usb debug デバイスなるものを使う debug 機能
# CONFIG_EARLY_PRINTK_DBGP
# CONFIG_EARLY_PRINTK_USB_XDBC
```



<!-- vim: set tw=90 filetype=markdown : -->
