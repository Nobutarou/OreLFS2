ASUS X555YA-DB84Q に LFS7.10 をインストールしているときのいろいろ

# Radeon 関係

## 簡潔なまとめ

radeon ドライバーはモジュールにすること。ファームウェアはモジュールじゃないと読み込めない

## 経緯

```kernel
fb: switching to radeondrmfb from efi vga
```

で停止する。一応、キーボード入力は生きていて、ログインと再起動はできる。起動オプションで nomodeselect つけると普通に EFI のフレームバッファーコンソールのまま起動する。

```zsh
journalctl -b 1
```

とかで、前回起動時のログが見てみると、

```journalctl
cik_cp: failed to load firmware "radeon/MULLINS_pfp.bin"
*ERROR* Failed to load firmware!
 radeon 0000:00:01.0: Fatal error during GPU init
```

最初のまとめの通り、モジュールにしてない限り読めないのだけど、そんなことに気がつかずにいろいろやってみた軌跡が以下。

* /lib/firmware にファームウェアをコピーする --> dynamic firmware loading が failure だかなんだか
* CONFIG_EXTRA_FIRMWARE=y で埋め込み --> 同じエラー。
* CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y --> 最悪の一手。完全にフリーズするから、ログインリブートもできないし、jounalctl にも残らない。

## Radeon その後

* Mesa17 にしたとき、xorg-server と xf86-drivers を更新する必要があった。今後注意
* SwapbuffersWait で VSYNC 止められるかと思ったけど、止まらなかった

# その他、起動時のエラー修正など

```
EXT4-fs (sda1): couldn't mount as ext3 due to feature incompatibilities
```

これは、カーネルがブート時にサポートされているファイルタイプを順番に試すからで /etc/fstab とは無関係らしい。でカーネルコマンドに

```kernel
rootfstype=ext4
```

を追加すればよいらしい。

```
 tpm_crb MSFT0101:00: can't request region for resource 
```
ホストの Ubuntu でも同じエラーが出てる。ぐぐると Alsa 周りらしいんだけで、Ubuntu ではそれでも音が出てるから、まあとりあえず放置しておこう

```linux
rtlwifi firmware rtlwifi/rtl8723befw.bin not available
```
```linux
Bluetooth: hci0: Failed to load rtl_bt/rtl8723b_fw.bin
```

radeon と一緒でモジュール化して解決

# カーネルログ
ネットワークとか USB 関連がコンソールを汚すので抑える。/etc/syctl.d/printk.conf などとファイルを作って

```conf
kernel.printk = 3 4 1 3
```

としておく。デフォルトは 4, 4, 1, 3

# タッチパッド

ps/2 マウスとして認識されてしまうため、xorg で evdev ドライバーで動いてしまう。普通に動く
ことは動く。どうも Bios の更新でタッチパッドとして認識され synaptics ドライバーで動く模様
。緊急時にしか使わないからジェスチャーとかは別に良いのだけど、普段は邪魔なので無効にしたい
。

https://is.gd/EB2UCz

ここに evdev デバイスの無効化の方法があるので、まねする。id がいつも同じだと良いけど、変化
してもこれくらいなら、自分でスクリプト書けそうだ。

# How to install deb files and manage.

Graft! http://peters.gormand.com.au/Home/tools

# LCD backlight

fn-f5, f6 を xorg で使うと固まる。journalctl -b0 さんは

```dmesg
kernel: [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
kernel: [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
```

```zsh
 ls /sys/class/backlight/ 
```

は radeon_b10 となる。acpi_xxx とならない。

archwiki を見ながら, 起動パラメータに

```grub
video.use_native_backlight=1
```

を追加すると、fn-f5, f6 は効かないままだけど、ハングはしなくなった. 最低限の安定性はこれで
保てる。

```grub
acpi_osi=Linux acpi_backlight=vendor
```

これも fn-f5 が効かなくなるが、ハングはしない。ま、とりあえずハングさえしなければ cat でど
うとでもなるから、最初のを採用しておくか

## Wifi 関連

wifi が ソフトブロックされていたので、

https://wireless.wiki.kernel.org/en/users/Documentation/rfkill

から rfkill をダウンロードしてインストール

```zsh
rfkill list
```

で確認し、

```zsh
rfkill unblock wifi
```

でブロックを解除する。

さて wpa_cli が

```zsh
Could not connect to wpa_supplicant: (null) - re-trying
```

となるし、手動で作った設定ファイルも

```zsh
 # wpa_supplicant -B -i interface -c /etc/wpa_supplicant/wpa_supplicant-wlp1s0.conf
 Successfully initialized wpa_supplicant
 Could not read interface interface flags: No such device
 nl80211: Driver does not support authentication/association or connect commands
 nl80211: deinit ifname=interface disabled_11b_rates=0
 Could not read interface interface flags: No such device
 interface: Failed to initialize driver interface
```
となってパニくったけど、
```
#cat /etc/wpa_supplicant/wpa_supplicant-wlp1s0.conf
	ctrl_interface=/var/run/wpa_supplicant
	ctrl_interface_group=wheel
	update_config=1
```

で自分を wheel グループに入れて

```zsh
systemctl start wpa_supplicant
systemctl start wpa_supplicant@wlpas0
```
をやりなおしたら、wpa_cli はうまく行くようになった. wpa_supplicant コマンドが動かないのは
良くわからないけど、とりあえず、接続まで確認できたから、なんとかなそうだ wpa_supplicant コ
マンが動かないのは良くわからないけど、とりあえず、接続まで確認できたから、なんとかなそうだ

ただ、設定がめんどうそうなので今回は wicd ではなくて NetworkManager を試してみよう。

# r8169 イーサネット

これが有効になかなかならなかった。dmesg 等で、

```log
kernel: r8169 0000:02:00.0: Direct firmware load for rtl_nic/rtl8168g-3.fw
```

そのままググると出てくるので /lib/firmware/rtl_nic/ に置く。で rtl8168 はモジュールにする
。

で、NEC WX02 側の名前忘れた、あの LAN 接続用のアクセサリのやつは、コンセントに差さないと反
応しないみたい。

以上で普通にネットに繋がった。

# WX02 の USB 接続

USB 差しても 

```
 kernel: cdc_ether 3-1:1.0 enp0s16u1: renamed from usb0
```

が出てこない。YMobile の中華端末は出るのに。で Ubuntu で調べると rndis モジュールが
cdc_ether を呼び出すので、rndis	もモジュールでビルドする。rndis で make menuconfig 中に検
索すると、やたらと出てきて、どれなのかいまいち分からないので、全部モジュールにしておく。こ
のへんカーネルのヘルプっていまいちなところ。 

```
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
```

ここの rndis は m にできないんだよね。良くわからない。でとりあえず繋がった。

```zsh
#lsmod
root@usehage /home/snob # lsmod 
Module                  Size  Used by
rndis_host              5914  0
cdc_ether               5125  1 rndis_host
```

となるので rndis_host が効いたみたい.

```kernel
CONFIG_USB_NET_RNDIS_HOST=m
```

のようだ。とにかく、rndis 関係は全部 m (か y) にすると良さそうだ。

# NetworkManager

一般ユーザーで使う方法はやはり Arch wiki https://is.gd/YZnN1s

```
cat > /etc/polkit-1/rules.d/50-org.freedesktop.NetworkManager.rules
polkit.addRule(function(action, subject) {
  if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("network")) {
    return polkit.Result.YES;
  }
});
EOF
```

systemd-networkd だと使いたいネットワークを指定できない。wicd は有線は一つしか指定できない
。これは有線が複数でも選択できるしいいね

再起動してみると、/etc/resolv.conf が全く NetworkManager で行なったのと違う google dns に
されている。arch で調べると、
/etc/NetworkManager/NetworkManager.conf 
に

```
[main]
plugins=keyfile
dns=none
```

で NetworkManager が resolv.conf を書きかえなくなる。でもこれじゃない感じ。

それから
 /etc/dhcpcd.conf
に

```
nohook resolv.conf
```

で dhcpcd に書き換えさせないことになる。これが本体な気がする。

あと、

```
chattr +i /etc/resolv.conf
```

で兎に角 /etc/resolv.conf を書き換えさせなくするらしい。このコマンドは知らなかった

# パフォーマンスチューニング

https://is.gd/H5uIAi 

上記の archwiki などを参考にしつつ、まずは phoronix-test-suite で調べながらやってみる

## 初期状態

phoronix-test-suite run pts/fs-mark を実施。BlogBench, Compile Bench, Dbench 等が軒並、1
時間の予測をしてくるものだからスキップ。FS-Mark は 15 分予想だったけど、実際は 4 分くらい
で終った。

で、1000 files, 1MB size のテストで、16.00 

## ext4 の nobarrier

archwiki ではないが、ext4 はバリアのせいで遅いらしい。いきなり電源が切れてもファイルとジャ
ーナルの関係が矛盾しないようにするとかなんとかで、電源の確保さえできれば、なくても、まあ、
実際に困ることはなさそうで、切っている人も多いらしい。ノートPC なので停電とかあってもバッ
テリー分だけで、シャットダウンくらいまでには、持っていけるだろうと思うから、自分も使ってみ
る。/etc/fstab に

```fstab
/dev/sda6     /            ext4    defaults,nobarrier            1     1
```

で FS-Mark の 1000 files, 1MB で 71.5 をマーク。いいね

これならと思い、BlogBench、Dbench を試してみたけど、5 分経っても 1 回目の計測が終らないの
でやめた。

## I/O スケジューラの noop

前回までは cfq だった。今回は noop. root で 

```sh
echo noop > /sys/block/sda/queue/scheduler
```

で書き換え可能

で FS-Mark, 1000 files, 1MB で 76.08 

## deadline 

スケジューラに deadline

で FS-Mark, 1000 files, 1MB で 75.5  

微妙な差。一応 noop にしてみる。

## multi queue

elevator=noop scsi_mod.use_blk_mq=1 でやってみたつもりだけど有効になってるのか分からない。
/sys/block/sda/queue/scheduler が none になってる。
/sys/block/sda/mq というフォルダがあるから有効か？
スコアも 72 くらいだ。

udev で noop にするようにしたけど scheduler は none だ。mq 使うと none になるのかな

udev ルール消してけど、none だ。てことは multi queue と通常のスケジューラは排他的ってわけ
だ。

```
    Test Results:
        56.4
        75.7
        76.7
        75.9
        76.6
        76.8

    Average: 73.02 Files/s
```

とこんな感じで一回目が遅い。

```
    Test Results:
        72.1
        75.4
        77.9
        77.2

    Average: 75.65 Files/s
```

もう一回やると安定してきた。ま、noop は古臭いし、こっちが最新だと言うんだから、これで行こ
うかな。

# Radeon 調整

R600_HYPERZ=1 で Hyper-Z を有効にしても、vblank_mode=0 で vsync を無効にしても apitest で
スコアがまったく伸びない。



# 番外編 Windows10

LFS は 64 bit 単独なので Steam client は動かない。マルチブートの Ubuntu は動くけど、Linux
を Black box 化してるわりに、端末を立ち上げっぱなしにしないと使えないとか、意味不明な設計
なのでクソみたいで使いたくない。同じブラックボックスなら一日の長のある Win10 の方が使いや
すい。

のだけど、何故かくそ遅い。タスクマネージャーで見ても CPU が動きまくってる分けじゃないのに
。ということで最初に気付いたのが IPV6 の削除。ていうか、Wifi 端末が対応してないなら自動で
切ってくれても良さそうなのに。たとえば NetworkManager みたいにユーザーがすぐ見つけられると
ころからは隠してるんだからさ。ただ、これで web の反応は良くなるんだけどまだ続く。

それから Windows Defender。これ Win7 のころはリアルタイムスキャンなかったと思うんだけで、
いつのまにかするようになってる。Steam からゲームをダウンロードしているときに、なぜかネット
ワーク速度が 0b/s となってしまい、最初ネットワークが切れたのかと思ったけど、良くみたら HDD
速度が 9kB/s とかになっていたときにタスクマネージャーを見たら Defender ががんがん動いてい
たので気が付いた。これ、ファイルがなんであっても全長検索してるね。しかも多分毎回。ウィンド
ウズアップデートがやたらと時間がかかるのも、100kB くらいの zip 開くのに 10秒くらいかかるの
もこのせい。real time scan を止めると 1MB/s (十分遅い気がするけど) とかになった。というわ
けで Avast を入れた（評判の良いのならなんでも良いと思うけど）。で zip 解答とかも大丈夫にな
った。Avast の設定を見ると、実行ファイルやライブラリだけ検索、しかも一回検索したらもうしな
いという、まあそうだよね、という設定になっていた。アンチウイルス入れたら高速化するとかどん
な設計なんだよ。

あと Indexing もやたらめったら重い原因だったので止めた。そんなんなくても Everything ってや
つで、超高速に検索できるし。

というわけで、Ubuntu も使いにくいけど、Windows も変なので LFS でマルチライブラリやってみよ
うかという気になってる。DualShock4 はカーネル対応してるみたいだし（タッチパッド部分も対応
してんのかは気になるけど）

<!-- vim: set tw=90 filetype=markdown : -->
