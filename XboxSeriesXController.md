# 有線接続

kernel 標準の xpad ドライバーで動く

# Bluetooth 接続

まずコントローラーが動くとかそういう前に bluetooth 接続が確率しない。ずっと
connect/disconnect を繰り返すか、Linux 上でペアリングできたことになっていても、実際は電源
ボタンがずっと点滅していて正しく接続出きない。

## コントローラーのファームウェアアップデート

Windows10 で Xbox アクセサリーアプリをインストール

https://www.microsoft.com/ja-jp/p/xbox-%E3%82%A2%E3%82%AF%E3%82%BB%E3%82%B5%E3%83%AA%E3%83% BC/9nblggh30xj3?activetab=pivot:overviewtab

ちなみに hosts でブロックとか Spybot とかしてたらストアが動かなかった。ただアップデートも
来てたので、本当の原因は分からない。まあ Windows はネットワークやセキュリティ関連はそのま
ま使うほうが問題が起きにくいかも。

そして有線接続をすればアプリでファームウェアアップデートができる。

どうも Web 上では、これだけで上手く行く環境もあるらしい。自分は自分LFS だけでなく、最新
Ubuntu, 最新 Manjaro を試したけど駄目だった。Qualcomm Atheros のチップは特別なのかもしれな
い。

## Kernel 5.13 系に

Web では上記に加えて Kernel 5.13 系で修正される環境もあるようだが、自分は駄目だった。これ
は自分カーネルだけでなく、最新の Manjaro で 5.13 試したけど駄目だった。Qualcomm Atheros
は。。。

## VirtualBox で Windows10 でペアリング

VirtualBox は本体だけでなく Extension Pack と言うのがないと、USB をゲストに渡せないので入
れる。

https://www.virtualbox.org/wiki/Linux_Downloads

で All distributions を選ぶ。インストール時にカーネルモジュールをコンパイルする。カーネル
5.12 くらいから clang でコンパイルできるので、そうしてるのだけど、これは gcc を強制的に使
うので clang のシンボリックリンクを gcc にする、などしておかないとコンパイルできない。とい
うところでちょっと躓いた。

Extension Pack のインストールは root でやらないと失敗した。

```
VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.26.vbox-extpack
```

あとはユーザーを vboxusers (VirtualBox インストーラが作る) に加えたら、ホストの USB をゲス
トに渡せる。

内蔵の bluetooth アダプタが USB 上にあるというのは本件で初めて知った。

あとは Windows 10 ダウンロード とでも検索すれば、インストーラ ISO は簡単に見つかるでしょう。

VirtualBox マシンに Win10 をインストールして、コントローラーを Bluetooth 接続すれば、この
作業は完了.

## 本体側でもう一度ペアリング

良く知らないが Bluetooth というのは機器が鍵を交換するらしい。
そしてそれを覚えておくみたい。
良く知らないけど。なので全く同じアダプタを使うのが味噌のようだ。

ここまでくるとあっさりペアリングが出きた。Web では起動毎にペアリングが必要な環境もあるらし
いが、自分は、この後は、両者の電源を入れたらすぐ接続するようになった。

疲れた。無線は良い。ケーブルでも使ってる間は違和感ないんだけど、準備と片付けが面倒くさい。

<!-- vim: set tw=90 filetype=markdown : -->

