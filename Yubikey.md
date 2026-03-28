# Yubikey 諸注意

Webサイトで二段認証に使うだけなら、カーネルで usb3 に相当するやつを y|m にしておくだけで、
勝手にキーボードとして使える

# Gnupg 
## 使うための準備

まず root で ``gpg --card-status`` しても見つからない問題が発生。
そこで libusb にリンクさせるように、もう一度ビルド。
それでも解決せず。

Archwiki によると pcsclite が必要ぽい。``man scdaemon`` するとデフォルトで libpcsclite.so
を使う。いやいや、ビルド時にリンクさせといてくれよ。いや、もしかすると代替があるのかも。そ
れならそれで、必要なライブラリが見つからないというエラーを出してほしい。
pcsclite すると無事 ``gpg --card-status`` が通った。

次は user で同コマンドしても見つからない問題。``udevadm monitor --environment --udev`` で
抜き差ししてみると /dev/hidrawXと /dev/bus/usb/XXX/XXX に該当するようだ。番号は抜き差しの
たびに変わる。そこでそれらのグループをユーザーにして +rw 権限あたえると、見つけられた。

そこで /etc/udev/rules.d/69-yubikey.rules ( これは Yubikey personalize tool をインストール
すると付いてくる) に

```
ACTION!="add|change", GOTO="yubico_end"

# Udev rules for letting the console user access the Yubikey USB
# device node, needed for challenge/response to work correctly.

# Yubico Yubikey II
ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0010|0110|0111|0114|0116|0401|0403|0405|0407|0410", \
    ENV{ID_SECURITY_TOKEN}="1"

# Here, I add.
# It enable for users to do 'gpg --card-status'
ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0116", GROUP="users", MODE="0664"

LABEL="yubico_end"
```

これで ``gpg --card-status`` が通った。

```
% gpg --card-status
Reader ...........: 1050:0116:X:0
Application ID ...: D2760001240102000006048867170000
Version ..........: 2.0
Manufacturer .....: Yubico
Serial number ....: 04886717
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
%                                                          
```

ま、お一人 Linux なら sudo でも良いんだろう。

## 実際に鍵を移す 

https://github.com/drduh/YubiKey-Guide の通りにやるのだけど、秘密鍵はすでにあるので、
.gnupg をコピーして、そこで副鍵作るところからやる。

秘密鍵の主鍵はこの人の方法では移さないで、副鍵だけ移す。そこに公開鍵も移さないと、それが誰
のものか分からなくなるというのは、ちょっとはまった。

最後はこれまでの .gnupg を消して終了。

とりあえず垢とるためにフォークしといた。

## 使ってみる

実は使ってみるまでどう使うのか全く分からなかった。。最終的にこれまでの .gnupg は消すので
、 Yubikey を差さないと、gpg が使いものにならなくなる (これまで使ってた鍵に関しては)。これ
までは、主鍵のパスワードを聞かれてきたが、これからは、Yubikey の Pin または admin pin を聞
かれることになる。つまり使うときの手間は何も変わらないということだ (pin をものすごく短かく
しない限り)。 Yubikey 持って、サーバーから公開鍵を入手できればどこでも使えるということに、
なるのかな。うん、自分には使い道がないね。

ただ安全面では、自分が留守のときに PC を盗まれても、暗号化済のデータは完全に守れるというこ
とだな。

<!-- vim: set tw=90 filetype=markdown : -->
