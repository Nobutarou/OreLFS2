よくわからないオプションを n や m にしていって、OS が動くのかどうか試す。y が推奨の項目は
n にしない。

system が呼べる関数を増やすみたいなのは、適当に Arch のにならっておく

一つ変更しらた再起動して geekbench4 や glxgearx, (heaven 長いからたまに ) で影響を見ておく。

# まとめ

影響があった項目一覧

* CONFIG_CC_STACKPROTECTOR_NONE=y
** strong は遅くなる
* CONFIG_TRANSPARENT_HUGEPAGE= y
** CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y. madvise は元に戻ってしまう
* CONFIG_HZ_100
** 少なくてもシングルタスクには効くようだ
* CONFIG_IDLE_PAGE_TRACKING=n 
** y はマルチスレッドを少し遅くするみたい

# CONFIG_USELIB=y --> n

glibc 使ってるシステムには不要らしい。Arch も n。なので n

--> 問題なく動く

# CONFIG_NO_HZ=y --> n

古いシステムとの互換性のための何か。Arch も n。なので n

--> 問題なく動く

# CONFIG_TASK_XACCT=y --> n

分かんなければ n ということで n. Arch は y だけど。

--> 問題なく動く

# CONFIG_CGROUPS=y --> n

unsure なら N らしいし、使ったこともないので。優先度の管理とかをグループごとに変えたりすん
だろうね。ボッチOS には無関係?

--> 
radeon firmware を読みこめずに起動しない（起動してるけど画面が真っ暗でなにもできない）

```
10月 06 15:40:50 usehage kernel: cik_cp: Failed to load firmware "radeon/MULLINS_pfp.bin"
10月 06 15:40:50 usehage kernel: [drm:cik_init] *ERROR* Failed to load firmware!
10月 06 15:40:50 usehage kernel: radeon 0000:00:01.0: Fatal error during GPU init
```

ccache のせいかと思い、ccache 無効. make clean したけど動かない

# CONFIG_SCHED_AUTOGROUP=n --> y

デスクトップ環境での体感速度向上らしいし、Arch も y だから、試す。

--> 問題なく動く

# CONFIG_RELAY=y --> n 

unsure なら n らしいから。いくつかのネットワークカードで強制 y になるみたい。

テラリアのカクツキは変化なし。Heaven は 376。まあ誤差の範囲。

--> 問題ないように思える


# CONFIG_DRM_RADEON_USERPTR=n --> y

user pointer がなんなのか全く分からない。

--> 起動時しばらく真っ暗な時間が長いようだが、その後は、問題なく動いているように見える。ただし何も違いがないように見える。

# CONFIG_DRM_AMDGPU_USERPTR=n --> y
user pointer がなんなのか全く分からない。

--> 画面が真っ黒のまま. jounalctl -b1 で見てみると、何故か radeon が firmware の取得に失敗
している。blacklist に入れてんのに。

気持悪いので、AMD, RADEON ともに userptr は無効にしておこう

# CONFIG_HSA_AMD=n --> m

HSA が何か知らないけど

--> amdkfd というモジュールが読みこまれたから、何かハード的に対応してるんだろう。
glxgears は 3400fps くらいで、これまでと変わらないし, heaven も 375 で別に変化ないし。
ま、ただ、そういうハードであるならとりあえずモジュールは継続しておこう

# CONFIG_CROSS_MEMORY_ATTACH=y --> n

make tinyconfig で n だから、中身知らないけど n にしてみる。if unsure が無い。

--> geekbench4 も普通に動いているし問題なさそう。

# CONFIG_SLAB=y

デフォルトは slub だけど、なんでも試してみよう

--> geekbench4 ではスコア一緒。https://is.gd/y8sqYE によると、開発っぽい人が SLUB 使っとけ
ば OK と言ってるので SLUB に戻す。 

# CONFIG_SLUB_CPU_PARTIAL=y --> n

リアルタイムシステムなら no かなあと書いてある。

--> geekbench4 で変化なし。

# CONFIG_PROFILING=y --> n

なんのことか分からない。

--> geekbench4 的には何も変わらない

# CONFIG_JUMP_LABEL=y --> n

> generally makes the kernel faster

て言ってるけど、どれくらい遅くなるのかな？まあ速くなると言ってるので、geekbench で変化がな
かったら、y に戻すことにする

--> 変化なし。y に戻しておこう

# CONFIG_CC_STACKPROTECTOR_NONE --> STRONG

なんか Arch は Strong にしてる。ググる限りでは、安定性が上る代わりに、パフォーマンスが落ち
そうだけど。geekbench で変化なければ none に戻すことにする。

--> Geekbench4 で、これまでシングルコアで平均 1450、標準偏差 6 のところが 1420, マルチコ
アで平均 3527、標準偏差 28 のところが 3408. これは遅くなってるでしょう。

# CONFIG_SMP=y --> n

SMP を無効にしてみる。

--> シングルスレッド性能上がるかもと言う期待をしてたけど、geekbench4 で変化なし。
Heaven では 10pt 下がる。これは無しだな。

# CONFIG_X86_MPPARSE=y -> n

acpi をサポートしない古いCPU向けの機能らしい。

--> 普通に動く。

# CONFIG_NR_CPUS=64 -> 4

CPU 1 個につき kernel size が 8kb 増える？

--> 問題なし.
ところで、Geekbench が 4.0.3 から 4.10.0 になっている。試したところシングルスレッドは 20
くらい向上して、マルチスレッドは 150 くらい向上している。ただし、OpenCL がやりたかったため
に llvm も 3.9.1 から 4.0.0 に上げてるので、本当に Geekbench だけの向上かは不明。

上記、Geekbench で詳細を比較したら llvm だけスコアが跳ね上がってるのを確認。

# CONFIG_PREEMPT_VOLUNTARY --> NONE

サーバー向けと言うことらしいけど。

--> まず、起動後、変化を感じない。Geekbench4 で変化なし。Heaven で 382 という過去最高点を
記録。Terraria のカクツキは改善なし。カクツキは Mesa 次第なんだろうな。とりあえずそのまま
採用。

# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y --> n

tiny では最初から出ていない。パフォーマンスに関係ある気もしないし、メーカー製 PC で IRQ 取
得がおかしくても困る。

--> なにも問題なさそう. 採用

# CONFIG_SCHED_OMIT_FRAME_POINTER=y --> n

これを n にすると overhead が少し増えるとあるがどうだろう。tiny では n になっている。

--> なにも問題なさそう。採用しておく

# CONFIG_X86_MCE=y --> n 

前の PC は良くオーバーヒートで強制シャットダウンしてたけど、この機能のせいだったのかな？今
の PC はオーバーヒートしたことないから、これがパフォーマンスに影響出るようなら n, 影響ない
なら安全策で y としよう

--> 変わらない。y に戻す。

# CONFIG_PERF_EVENTS_AMD_POWER=y --> m

15h family 向けらしいが、A8 は 22th らしいので、そもそも有効になるのかどうか。

--> /lib/modules/kernel/arch/x86/events/amd/power.ko のようだが、lsmod で読みこまれて
いない。Geekbench4 も変化なし。そのまま m にしておく。

# CONFIG_X86_MSR=y --> m

何かがこれを必要としていた気がするけど思いだせない。ま m なら良いでしょう。

--> msr はデフォルトで読み込まれない。Geekbench4 にも変化はない。m を続行。

# CONFIG_X86_CPUID=y --> m

これも何かに必要だった気がするけど思い出せない。m にしてみる。

--> デフォルトで cpuid はロードされてない。Geekbench4 で変化がないので、m 続行。

# CONFIG_SPARSEMEM_VMEMMAP=y --> n

何か重要そう。tiny は n. 変化がなければ y に戻す。

--> Geekbench4 で変化なし。y に戻す。

# CONFIG_COMPACTION=y -> n

メモリの断片化をくしゅっとして解消するらしい。tiny では n. 変化なければ y に戻す。

--> 変化なし。y に戻す。

# CONFIG_BOUNCE=y --> n

メモリの全領域を使えない CPU 向けの機能とか言われても分からない。なんか今時のハードウェア
っぽくないので、変化がなければ n 採用で。

--> 変化なし。採用

# CONFIG_KSM=n --> y

同じ内容のメモリを一つにまとめる？スピードに関しては遅くなりそうなイメージ。もちろんよくわ
からないので、変化がなければ n に戻す。

--> 変化なし。n に戻す。

#  CONFIG_DEFAULT_MMAP_MIN_ADDR=4096 --> 65536

x86 ならこれで良いんじゃねと書いてあるから。

```
/proc/sys/vm/mmap_min_addr
```

を書きかえられる的なことが書いてあるので、コンパイルせずに試せる。

--> 変化なし。ま 65536 をヘルプが薦めてるから 65536 にしておくか。

# CONFIG_TRANSPARENT_HUGEPAGE=n --> y

なんかモードを選択しなくてはならないので CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y にしておく。

y するとパフォーマンス上がるとか言ってる。まあ変化なくても y 続投で、もう一つの madvise と
か言うモードにも挑戦だな

--> Geekbench4 のシングルスレッドが改善してる？memory latency のスコアが上がってるようだ。
このまま採用として次は madvise 

# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y

こっちの方が HUGEPAGE の効果があるときだけ有効にするらしくて効率良さそうなので、変化がなけ
れば、こちらとしよう。

--> 元に戻ってしまった。ALWAYS に戻す。

# CONFIG_FRONTSWAP=n --> y

n だとパフォーマンス落ちるみたいな表記で unsure なら y らしいので、変化がなくても y にしよ
う。

--> 変化なさそうなので y 継続

# CONFIG_X86_CHECK_BIOS_CORRUPTION=y --> n

なんか余計なチェックなんかしないほうが良さそうだけど。変化なければ n にする。コンパイルし
なくても memory_corruption_check=0 で起動すれば良さそう。

--> 変化なしなので n を採用。カーネルもこっそりビルドしなおしておく。

# CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1 --> 5

mtrr_spare_reg_nr=5 を カーネルオプションに付けて起動すれば良いらしい。 5 の根拠は https://is.gd/KOgdae 

dmesg で 
```dmesg
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFE0000000 write-back
[    0.000000]   2 base 009F000000 mask FFFF000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
```

の disabled というのがフリーなメモリでスペアの数とするんだそうだ。

# CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1 --> 0

ところが https://is.gd/ubzLbW の Gentoo Wiki では GPU に割り当てられているレジスタの番号とし
ろと書いてある。

```zsh
% cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size=  512MB, count=1: write-back
reg02: base=0x09f000000 ( 2544MB), size=   16MB, count=1: uncachable
```

なので 0 なのか？

いや良く読むと PAT は MTRR を置き換えるものらしい。ということで /proc/cpuinfo を pat で
grep するとサポートされてるし、

```dmesg
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT
[    0.000000] total RAM covered: 2544M
[    0.000000] Found optimal setting for mtrr clean up
```
ということで PAT が mtrr clean up さんを最適化してくれてるみたい。

ということで、この項目は放置しておこう。

# CONFIG_HZ_1000 --> CONFIG_HZ_100

NUMA さんなら 100Hz で十分だというようなことがヘルプに書いてある。変化を感じなければ 100
採用で良いかな。

インストールまではやったので、あとはテストだ。

--> GeekBench4 過去最高得点、シングルコアは 20pt くらいだけどマルチコアで 100Pt くらい上が
る。念のため、もう一回やる。ちょっと下ったけどそれでも歴代 2 位を維持。

Heaven も 385pt という過去最高得点。なお max fps が 24.6。24 台は初めて。

なお、ターミナルとブラウザの切り替えとか、なにも支障がない。

ということで、100 を採用する。

# CONFIG_CLEANCACHE=y --> n

ちょっと順番が入れ替わるけど、やってみる。unsure なら y なので、変化がなければ y に戻す。

--> 変化なさそうなので y に戻す。

# CONFIG_FRONTSWAP=y --> n

これも unsure -> y なので、変化なければ y に戻す。

--> y に戻す。

# config_kexec=y --> n

これは推奨がない。kernel をシャットダウンして別のカーネルを起動できるらしい。普段普通の
reboot しか使ってないので、必要なことなんかあるのだろうか？起動させつづけないとならないサ
ーバーとか用の機能なのだろうか。とりあえず変化がなければ n にしてみる。

--> なんか微妙にパフォーマンスが下がるので y に戻す。

# CONFIG_CMA=n --> y

unsure なら n らしいので変わらないなら n に戻す。

--> n に戻す

# CONFIG_ZSWAP=n --> y

多分 swap 使ってないので無意味だと思うけど。変わりなければ n に戻す。

実は操作を間違って、先の CMA=n のカーネルを消してしまったので、今回 CMA=n も同時にやってい
るので、インストールを忘れずに。

--> n に戻す。一旦、n のカーネル作って入れかえる。

# CONFIG_ZPOOL=y --> m

memory storage ってメモリディスクのことかな？使わないから m で。変化なければ n に切り替え

--> lsmod で zpool は入ってない。消しても良いけど m 続行で。なお、Geekbench4 は X 起動せず
にコンソールログインで行なっても、スコアに影響はないみたい。n に変更へ

# CONFIG_ZBUD=n --> m

多分変化ないだろうから lsmod で読み込まれてなければ n に戻す。

結果、変化なく、lsmod で読みこまれてないので n に戻す。

# CONFIG_ZSMALLOC=n --> m

これも読み込まれずに変化ないだろうから、そうしたら n に戻す。

結果、読み込まれてない。変化もない。n に戻す。

# CONFIG_IDLE_PAGE_TRACKING=n → y

効果なければ n に。

結果、やたら起動に時間がかかった。GB4 はマルチスレッドが 50pt くらい下った。n にする。

# CONFIG_X86_PMEM_LEGACY=n → m

まあ読み込まれないだろうから、そしたら n に戻す。

結果、はい、n に。

# CONFIG_CRASH_DUMP=y --> n に

どうせ何が書き出されてても理解できないわけだし。

結論、n に。

# CONFIG_PM_DEBUG=y → n

debug いらないんじゃない？

結論, n に

最近、BM4 の multi core がバラツクということがはっきりしてきた。シングルで 1515 ± 10 くら
い出てれば OK そう。もしかしたら、systemdtimesyncd や NetworkManager のせいだったかも知れ
ないので、timesyncd は disable, NM は stop しておくのが良さそう。

# CONFIG_SUSPEND=y → n

買ってから使ったことないし、認証に network が必要で落とせないとかじゃないし、爆速起動の俺
Linux には不要。

# CONFIG_HIBERNATION=y → n

これも使ったことないから不要。

# CONFIG_WQ_POWER_EFFICIENT_DEFAULT=n → y

パワーを犠牲にパフォーマンスが上がると書いてある。カーネルコンパイルしなくても

```
workqueue.power_efficient
```

のカーネルオプションで有効にできる。変化なければ消す。

結果、変化ないから n のままとする。

# CONFIG_ACPI_PROCESSOR_AGGREGATOR=n → m

これが何か分からないが電力消費と関係があるらしい。モジュールがロードされなければ n に戻す
。

結果、ロードされないので戻す。

# CONFIG_ACPI_SBS=n → m

スマートバッテリーらしい。ロードされなければ n に戻す。

結果、ロードされなかったので n に戻す。

# CONFIG_X86_POWERNOW_K8=y → m

多分本機にこれは使われていない。load されなければ m で放置。 

結果、ロードされなかったので m で放置。

# CONFIG_X86_AMD_FREQ_SENSITIVITY=y → m

オンデマンドのガバナーに影響あるみたい。ロードされるかな。

結果、ロードされない。GB4 も変化なし。

```sh
% sudo modprobe amd_freq_sensitivity 
modprobe: ERROR: could not insert 'amd_freq_sensitivity': No such device
```

未対応だったか。とりあえず m のまま放置。

# CONFIG_PCIEAER=y → n

error reporting は要らないんじゃないかな。

結果、変わらないから無しで。

なお GB4 は次のように画面に文字を出さないほうが安定していりょうに感じる。
```
/opt/Geekbench-4.1.0-Linux/geekbench4 --save hoge 1> /dev/null 2>& 1 < n
```
ファイル n の中身は n で。

# CONFIG_PCIEASPM_DEFAULT → PERFORMANCE

消費電力とか気にしてないからパフォーマンス上がると良いな。

結果、変わらないから _DEFAULT に戻す。

# CONFIG_HOTPLUG_PCI=y → n

使わないよ。パフォーマンスに関係ないだろうけど。

# CONFIG_RAPIDIO=n → m

ロードされたら考える。

結果、ロードされなかったので n に戻す。

# CONFIG_X86_SYSFB=n → y

これで画面がブート直後から表示されないかな？

結果。されなかった。とりあえず画面の件はあとでやりたいから、y のままにしておく。

# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y → n

どうせ分析できないし n で良くね。

# CONFIG_PNP_DEBUG_MESSAGES=y → n

どうせ分析できないし、pnp.debug のカーネルオプションで有効にできるみたいだから n で良い。

# CONFIG_KERNEL_GZIP → LZ4

パフォーマンスに影響はないだろうけど、なんとなく gzip よりも、さらに lzo よりも展開が速い
とされる lz4 で カーネルを圧縮してみる。

結果は予想どおりパフォーマンスに影響はない。

# CONFIG_MEMCG=n → y

cgroup を有効にしないと radeon が firmware を読み込めずに起動できない問題があった。cgroup
がパフォーマンスに影響するか調べていく。

結果、変化ないけど、y 続行にしておく。

# CONFIG_BLK_CGROUP=n → y

cgroup の I/O 版。

変化はないけど, y 続行で。

# CONFIG_CGROUP_FREEZER=y → n

cgroup2 の memory controller に統合されているらしい。CONFIG_MEMCG のことかな？

結果、やたらと起動に時間がかかったから y に戻しておく。

# CONFIG_KEYS=y → n

unsure なら n らしいので。

# より道
<!-- {{{ -->
起動時にしばらくコンソールが出ないので、

```
CONFIG_FB_EFI=y #もともと
CONFIG_FB_VGA16=m
CONFIG_FB_VESA=y
CONFIG_FB_SIMPLE=y
```
どれかで表示してくんないかなと期待。

dmesg では
```
[    0.417895] efifb: probing for efifb
[    0.417917] efifb: framebuffer at 0xe0000000, using 1984k, total 1984k
[    0.417923] efifb: mode is 800x600x32, linelength=3328, pages=1
[    0.417929] efifb: scrolling: redraw
[    0.417935] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
```

とあるが、このあたりは真っ黒。

```
[    9.272324] fb: switching to radeondrmfb from EFI VGA
[    9.272379] Console: switching to colour dummy device 80x25
```

この辺りから見える。とりあえず後回し。

```
CONFIG_FB_EFI=n
CONFIG_FB_VGA16=n
CONFIG_FB_VESA=n
CONFIG_FB_SIMPLE=n
```
だとどうかな。結果は、radeon のfb が始まるまで何も表示されない。これまでは一瞬 EFI FB らし
きものが映っていた。

```
CONFIG_FB_EFI=n
CONFIG_FB_VGA16=n
CONFIG_FB_VESA=n
CONFIG_FB_SIMPLE=y
```
はどうかな？カーネルは FB の認識を行なわず、すでに開いている FB に描画を試みるらしい。
GRUB2 の EFI の FB がそのまま流れてこないかなと期待したのだけど

```
[    0.853338] simple-framebuffer simple-framebuffer.0: format=a8r8g8b8, mode=800x600x32, linelength =3328
[    0.853396] simple-framebuffer simple-framebuffer.0: fb0: simplefb registered!
```

と dmesg 上は期待通りの動きだけど、実際はしばらく真っ暗で radeon に切り替わる少し手前で一
瞬表示されるだけ。

```
CONFIG_FB_EFI=n
CONFIG_FB_VGA16=y
CONFIG_FB_VESA=n
CONFIG_FB_SIMPLE=n
```

EFI FB を VGA16 が上書きしてくんないかな？結果は、
```
[    0.858101] vga16fb: initializing
[    0.858104] vga16fb: mapped to 0xffff8800000a0000
[    0.858196] fb0: VGA16 VGA frame buffer device
```
とかなり初期に vga16 fb が動いていることになっているが、実際は radeon に切り替わる直前に画
面が真っ白になるまで、ずっと真っ黒のままで期待外れ。

どうせどれもだめなら、全部 n で良いだろう。
<!-- }}} -->
<!-- vim: set tw=90 filetype=markdown fdm=marker cms=<!--\ %s\ -->: -->
