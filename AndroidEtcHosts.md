Android の /etc/hosts を pc 側から書き換えたい。

# Android 開発ツールのインストール、セットアップ

commandlinetools というのが zip でころがっているので展開
https://developer.android.com/studio#cmdline-tools

cmdline-tools というフォルダに展開されるが罠がある。
https: //stackoverflow.com/questions/65262340/cmdline-tools-could-not-determine-sdk-root

cmdline-tools ディレクトリに tools ディレクトリを作成して中身を全部そこに移す
例えば /source/androidsdk/cmdline-tools/tools/bin/sdkmanager と言う具合になる。

で adb をインストール

```
./sdkmanager "platform-tools"
```

先のディレクトリ構成だと /sources/androidsdk/platform-tools にインストールされる

# パーミッション、udev ルール
https://developer.android.com/studio/run/device

を参考にユーザーを plugdev グループに所属させる.

https://github.com/M0Rf30/android-udev-rules/

から 51-android.rules を拝借する.
しかし adb devices で何も表示されない.
と言うのも GROUP 指定が plugdev になってなかったから。書きなおした

# カーネルかなあ？ --> 関係なかった

こんなときに限って GentooWiki にカーネル設定情報がない。しかたないので Arduino で代用

https://wiki.gentoo.org/wiki/Arduino#Prepare_the_kernel_for_USB_connection

```
# これかと思ったけど違うかった
CONFIG_USB_ACM=m
```

次は CONFIG_USB_SERIAL を片っ端から =m または =y にしてみる。明かに不要なのもあるが、とり
あえず全部やる

CONFIG_USB_GADGET 以下も m にしてみる


# /etc/hosts を書き換える

USB 接続して usb デバッグモードを有効にする。
タブレット情報のビルド番号を 7回タップして開発者になる.


あとは下を参考にして
https://qiita.com/konifar/items/77744cf8179657adcc3e

```
adb pull /system/etc/hosts
adb push ./hosts /system/etc/hosts
```

<!-- vim: set tw=90 filetype=markdown : -->

