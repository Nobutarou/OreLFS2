# Maple Mini で OpenPGP Token が作れた話し

ここが参考

https://www.makomk.com/2016/01/23/openpgp-crypto-token-using-gnuk/

Aliexpress で購入したのは、Maple Mini と PL2303HX チップを使った USB-シリアルアダプタ。
Kernel config にそれっぽいのがあったから。そのほか、はんだと、メスーメスジャンパーケーブル
が必要だった。はんだは 白光 FX65082 [DASH/100V ゴム平形プラグ I付] というこて先の小さいも
のにしたが、実際は大き目の C タイプのほうが使いやすいのかも。ケーブルは ST-LINK V2 の遺品
が活用できた。

カーネルは次が必要。

```
CONFIG_USB_SERIAL_PL2303=m
```

Maple mini の回りの穴にオスのケーブル差しても接触が少なくて電流流れないので、ゲジゲジのハ
ンダが必要だった。

https://imgur.com/a/bUL87Za

で配線はサイトがちょっと不明で、実際には

- アダプタ GND - Maple mini GND
- アダプタ 3.3V - Maple mini VCC
- アダプタ TXD - Maple mini RX1
- アダプタ RXD - Maple mini TX1
- Maple mini GND - Maple mini boot1
- Maple mini VCC - Maple mini But

だった。次が参考になった。アダプタは物によっては TXD と RXD が逆のようだ。

https://wiki.stm32duino.com/index.php?title=Burning_the_bootloader

アダプタは /dev/ttyUSB0 となった. dialout グループに rw 属性が付いていたので自分を dialout
に入れれば一般ユーザーでも使える。

ARM 向けのクロスコンパイラは

https://developer.arm.com/open-source/gnu-toolchain/gnu-rm/downloads

からバイナリをダウンロードする。さすがにビルドするのは面倒。

stm32flash は 

https://sourceforge.net/projects/stm32flash/

特にビルドに困ることもない。

ここまでこれば、サイトの通りにできる。

```
# Gnuk build
git clone git://git.gniibe.org/gnuk/gnuk.git
cd gnuk/src
git submodule init
git submodule update
./configure --vidpid=234b:0000 --target=MAPLE_MINI
make -j3

# 書き込み
stm32flash -w build/gnuk.bin -v /dev/ttyUSB0

# 読み込み保護らしい
stm32flash -j /dev/ttyUSB0
```

これで完成なんだけど、このままだと一般ユーザーで使えないので root にて

```
udevadm monitor --environment --udev
# で抜き差しする
```

と

```
  looking at parent device '/devices/pci0000:00/0000:00:10.0/usb1/1-2':
    KERNELS=="1-2"
    SUBSYSTEMS=="usb"
    DRIVERS=="usb"
    ATTRS{authorized}=="1"
    ATTRS{avoid_reset_quirk}=="0"
    ATTRS{bConfigurationValue}=="1"
    ATTRS{bDeviceClass}=="00"
    ATTRS{bDeviceProtocol}=="00"
    ATTRS{bDeviceSubClass}=="00"
    ATTRS{bMaxPacketSize0}=="64"
    ATTRS{bMaxPower}=="100mA"
    ATTRS{bNumConfigurations}=="1"
    ATTRS{bNumInterfaces}==" 1"
    ATTRS{bcdDevice}=="0200"
    ATTRS{bmAttributes}=="80"
    ATTRS{busnum}=="1"
    ATTRS{configuration}==""
    ATTRS{devnum}=="14"
    ATTRS{devpath}=="2"
    ATTRS{idProduct}=="0000"
    ATTRS{idVendor}=="234b"
    ATTRS{ltm_capable}=="no"
    ATTRS{manufacturer}=="Free Software Initiative of Japan"
    ATTRS{maxchild}=="0"
    ATTRS{product}=="Gnuk Token"
    ATTRS{quirks}=="0x0"
    ATTRS{removable}=="unknown"
    ATTRS{serial}=="FSIJ-1.2.10-43134049"
    ATTRS{speed}=="12"
    ATTRS{urbnum}=="12"
    ATTRS{version}==" 2.00"
```

と言うのを見て /etc/udev/rules.d/69-gnuk.rules に

```
ACTION!="add|change", GOTO="gnuk_end"

# It enable for users to do 'gpg --card-status'
ATTRS{idVendor}=="234b", ATTRS{product}=="Gnuk Token", GROUP="users", MODE="0664"

LABEL="gnuk_end"
```

```
udevadm control --reload
```

次に差して 

```
gpg --card-status
```

で 

```
Reader ...........: 234B:0000:FSIJ-1.2.10-43134049:0
Application ID ...: D276000124010200FFFE431340490000
Version ..........: 2.0
Manufacturer .....: unmanaged S/N range
Serial number ....: 43134049
Name of cardholder: [未設定]
Language prefs ...: [未設定]
Sex ..............: 無指定
URL of public key : [未設定]
Login data .......: [未設定]
Signature PIN ....: 強制
Key attributes ...: rsa2048 rsa2048 rsa2048
Max. PIN lengths .: 127 127 127
PIN retry counter : 3 3 3
Signature counter : 0
Signature key ....: [none]
Encryption key....: [none]
Authentication key: [none]
General key info..: [none]
```

無事成功

ただし問題発生。gnupg の鍵束は一つの smart card しか使えない。GNUPGHOME で ~/.gnupg 以外を
示せば良いけど。。。ま、public key を読み込めば有効になるんだし、そんなに問題じゃないかな
。

やり直したくなったら

```
stm32flash -k /dev/ttyUSB0
```

でやりなおし

で副鍵を移したあとも 

```
General key info..: [none]
```

のままなんだけど、pass はちゃんと動くから、なんか Public key がおかしいのかもしれない。
public key は大昔に作ったのを使ったんだけど、副鍵作るときに作り直したほうが良いのかも。

基本的に鍵の移し方は http://no-passwd.net/fst-01-gnuk-handbook/index.html のとおりにやったほうが良さそう。公開鍵を --card-edit から fetch したらいけたし。


# ST-LINK V2 で OpenPGP Token を作ろうとしたけど無理だった話し。

ここを参考

https://medium.com/@mopemope/openpgp-card-%E3%82%92%E6%A0%BC%E5%AE%89%E3%81%A7%E6%89%8B%E3%81%AB%E5%85%A5%E3%82%8C%E3%82%8B-e84753ac1dc5

Gnuk のレポが変わってるようだ。

```
git clone git://git.gniibe.org/gnuk/gnuk.git 
```

ST-LINK V2 だけどプログラマーの穴のあるところに穴がなく、ハンダでぽちっとしてあるものだっ
た。ここにケーブルをはんだで付ければ良いらしいが、うまくできなかった。写真を見て、穴の空い
たのを選んでみたけど、届いたのは穴の無いやつだった。

ということで、ST-LINK V2 を使う方法は、電子工作素人には、不可能な場合があることが分かった
。
