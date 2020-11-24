よくわからないオプションを n や m にしていって、OS が動くのかどうか試す。y が推奨の項目は
n にしない。

system が呼べる関数を増やすみたいなのは、適当に Arch のにならっておく

一つ変更しらた再起動して geekbench4 や glxgearx, (heaven 長いからたまに ) で影響を見ておく。

4.7.2 のときは上からやってったけど今回は下からやってみる

# まとめ

4.7.2 のころに影響があった項目一覧

* CONFIG_CC_STACKPROTECTOR_NONE=y
** strong は遅くなる
* CONFIG_TRANSPARENT_HUGEPAGE= y
** CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y. madvise は元に戻ってしまう
* CONFIG_HZ_100
** 少なくてもシングルタスクには効くようだ
* CONFIG_IDLE_PAGE_TRACKING=n 
** y はマルチスレッドを少し遅くするみたい

起動しなくなるので y が必要な項目
* CONFIG_INOTIFY_USER=y
* CONFIG_SATA_AHCI=y

# CONFIG_KVM=y → m

たぶん不要だろう. 一応 BLFS で grep したら qemu だけヒットした。qemu 使わないから。

## 結果

予想に反して lsmod で kvm が読みこまれていた。irqbypass というモジュールで使われるらしい。
irqbypass が何かはもちろん知らない。

# CONFIG_CRYPTO_CCM=y → m

Wifi や USB 経由 LAN で読みこみそうだ。

## 結果

使われてないようだ。n は怖いので m を採用

# CONFIG_CRYPTO_GCM=y → m

ならこれも使われないのかな。

## 結果

使われてないようだ。n は怖いので m を採用

# CONFIG_CRYPTO_CTR=y → m

m にしたら CONFIG_CRYPTO_SEQIV も m が選択できるようになったけど、とりあえずこっちはそのままで

## 結果

使われてないようだ。n は怖いので m を採用

# CONFIG_CRYPTO_SEQIV=y → m
## 結果
使われてないようだ。n は怖いので m を採用

# CONFIG_CRYPTO_LRW=y → m
絶対使ってないだろう。
## 結果
使われてないようだ。n は怖いので m を採用

# CONFIG_CRYPTO_XTS=y → m

CONFIG_CRYPTO_ECB の y, m が選べるようになるけど後回し。

## 結果

使われてないようだ。n は怖いので m を採用

# CONFIG_CRYPTO_ECB=y → m
## 結果

使われてないようだ。n は怖いので m を採用

# CONFIG_CRYPTO_CMAC=y → m
## 結果

使われてないようだ。n は怖いので m を採用

# CONFIG_CRYPTO_CRC32_PCLMUL=y → m
## 結果

読み込まれている。他のモジュールからの呼び出しではない。Help によると CPU がサポートしてい
ればということらしいので、A8-7410 にはこの機能があるんでしょう。何か知らないけど。

m 採用。

# CONFIG_CRYPTO_CRCT10DIF=y → m
モジュール名: crc-t10dif

## 結果
crct10dif_pclmul から呼び出されてるようだ。m 採用。

# CONFIG_CRYPTO_GHASH=y → m
モジュール名: ghash-generic

## 結果
使われてないようだけど、n は怖いので m を採用

# CONFIG_CRYPTO_GF128MUL=y → m
モジュール名: gf128mul

## 結果
使われてないようだけど、n は怖いので m を採用

# CONFIG_CRYPTO_AES_NI_INTEL=y → m
CONFIG_CRYPTO_AES_X86_64 を選択できるようになる。

モジュール名: aesni-intel 以外にもいろいろ作られてた。気にしない。

## 結果
読み込まれてる。Intel ハードウェアということじゃなくて Intel の開発ソフトウェアということ
らしい。ややこしい。

# CONFIG_CRYPTO_CRYPTD=y → m
モジュール名: cryptd

## 結果
読み込まれてる。

# CONFIG_CRYPTO_AES_X86_64=y → m
モジュール名: aes-x86_64

## 結果
読み込まれてる。

# CONFIG_CRYPTO_ARC4=y → m
モジュール名: arc4

## 結果
読み込まれてる。

# CONFIG_CRYPTO_LZO=y → m
モジュール名: lzo
## 結果
使われてないようだけど、n は怖いので m を採用

# CONFIG_CRYPTO_ANSI_CPRNG=y → m
モジュール名: ansi_cprng

## 結果
使われてないようだけど、n は怖いので m を採用

# CONFIG_CRYPTO_DEV_CCP_DD=y → m
CONFIG_CRYPTO_DEV_CCP_CRYPTO も併わせて m になった

モジュール名: ccp

## 結果
読み込まれてる。

# CONFIG_KEYS=y → n
unsure な人は n らしいので。もちろん unsure.

## 結果
全く変化を感じないので n を採用

# CONFIG_SECURITYFS=y → n
BIOS の TPM とかいう暗号化を使わないなら不要らしい。もちろん使ってない

## 結果
全く変化を感じないので n を採用

# CONFIG_STACKTRACE=y → n
debug に興味なし.

## 結果
全く変化を感じないので n を採用

# CONFIG_TRACING_EVENTS_GPIO=y → n
debug に興味なし.

## 結果
全く変化を感じないので n を採用

# CONFIG_FTRACE=y → n
CONFIG_TRACING_EVENTS_GPIO の親。debug に興味ないので

## 結果
全く変化を感じないので n を採用

# CONFIG_PROVIDE_OHCI1394_DMA_INIT=y → n
絶対いらないだろう。

## 結果
全く変化を感じないので n を採用

# CONFIG_X86_VERBOSE_BOOTUP=y → n
n でもエラーは読めるらしい。どこまで減るのかやってみて決めよう。

## 結果
dmesg しても違いが分からないので、そのまま n を採用

# CONFIG_DNOTIFY=y → n
ファイル、ディレクトリの変更を通知する仕組みらしいが、使っている気がしない。

## 結果
一番使いそうな rox と thunar を起動してみたけど警告一つ出ない。n 採用

# CONFIG_INOTIFY_USER=y →n
## 結果
起動してるみたいだが画面が真っ暗で使いものにならない。jouranctl -b-1 するとエラーが出てる
。

``
7月 15 18:25:53 usehage kernel: ACPI Error: [^^^PB2_.VGA_.AFN7] Namespace lookup failure, AE_NOT_FOUND (20170119/psargs-363)
7月 15 18:25:53 usehage kernel: ACPI Error: Method parse/execution failed [\_SB.PCI0.VGA.LCDD._BCM] (Node ffff88021702cc80), AE_NOT_FOUND (20170119/psparse-543)
7月 15 18:25:53 usehage kernel: ACPI Error: Evaluating _BCM failed (20170119/video-343)
``

これは y 必須。

# CONFIG_NLS_CODEPAGE_437=y → m
モジュール名: nls_cp437

## 結果
NTFS マウントしても特になにもなし。m 採用。

# CONFIG_NLS_CODEPAGE_932=y → m
モジュール名: nls_cp932, nls_euc-jp

## 結果
そこらの USB 差したら nls_cp932 が読みこまれた。m 採用

# CONFIG_NLS_ASCII=y → m
モジュール名: nls_ascii

## 結果
とりあえず m 採用で

# CONFIG_NLS_ISO8859_1=y → m
モジュール名: nls_iso8859-1 

## 結果
とりあえず m 採用で

# CONFIG_NLS_UTF8=y → m
モジュール名: nls_utf8

## 結果
とりあえず m 採用で

# CONFIG_DMIID=y → n
/sys/class/dmi/id/ にいろいろ出してくれるものらしいが使ったことないので。

## 結果
とりあえず動いたので n のままでいってみる

# CONFIG_EFI_VARS=y → m
モジュール名: efivarfs

## 結果
読みこまれてる。m を継続

# CONFIG_EFI_RUNTIME_MAP=y → n
/sys/firmware/efi/runtime-map を使ったことが無いし

## 結果
無事起動。n を継続

# CONFIG_PROC_EVENTS=y → n
## 結果
無事起動。n を継続

# CONFIG_CONNECTOR=y → m
モジュール名: cn

## 結果
とりあえず m

# CONFIG_DRM_LOAD_EDID_FIRMWARE=y → n
ハードが壊れてないなら不要らしい。

## 結果
普通に x の起動までできたので n 継続

# CONFIG_FIRMWARE_EDID=y → n
ブート時に画面になにか出るまでの時間が長いなら n で改善するかも、らしい。

## 結果
真っ黒時間が変わった気はしないけど、まあ n で良いや。

# CONFIG_SATA_AHCI=y → m
モジュール名: libahci かな

## 結果
カーネル起動できない。 y 必須。

<!-- vim: set tw=90 filetype=markdown fdm=marker cms=<!--\ %s\ -->: -->
