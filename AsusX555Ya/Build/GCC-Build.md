# GCC で FDO, LTO に挑戦

無理なのかと思っていたけど、可能だった。

## 全部ここに書いてあった

https://gcc.gnu.org/install/build.html

## FDO 基本

``
make profiledbootstrap
``
## FDO に -march=native を入れたい

GCC のビルドはデフォルトだと -O2 くらいしか入れてくれないので BOOT_CFLAGS を使う。これは三
回のビルドのうち、二回目と三回目の CFLAGS に追加てくれるオプション。

``
make V=1 BOOT_CFLAGS='-march=native -O2' profiledbootstrap -j3
``

などとする。V=1 は -march=native が本当に入っているか確認のため。

正直 gcc を PGO する価値のある人は毎日死ぬほどコンパイルしている人だけだと思う。普通の LFS
ユーザーでは PGO に掛けた時間をとりもどせない。

## 高速ビルドの案 (没)

PGO したいのは libstdc++.so だけだし、libstdc++.so をなんのコンパイラでコンパイルしようが
かまわないので、libstdc++.so だけ PGO 準備ビルドしたらインストールして、プロファイル集めて
2 回目のビルド

そして、gcc は --disable-bootstrap 使い自力の bootstrap をする。一回目は -O1 とかでビルド
してインストール。二回目は一回目の gcc で -O2 -march=native あたりでビルド

実際には libstdc++.so が全然プロファイルを吐かないので断念。


## PGO スピードアップのアイデアその2

普通にビルドして、次に ../libstdc++-v3/configure して make してみた。cflags や ldflags が普通に通っている模様。次回は時間短縮のために試してみよう 

## 普通に build して、次に --disable-bootstrap で PGO 準備して、最後に --disable-bootstrap で PGO できるかテスト

うーん、正規の FDO して寝てればいいか. LLVM と違って、動かないとすごく困るわけだし、stage 2 のプロファイル書き出し用バイナリで問題でると困るから、寝てればいいか。

## 普段の FDO みたいにできるかテスト

一回目、

``
make V=1 BOOT_CFLAGS='-march=native -O2 -fprofile-generate  -fprofile-arcs ' -j3
``

とかやるとなぜかステージ1 で gcov 関連で落ちた。ステージ 1 は CFLAGS が効くみたいだから、
CFLAGS からは fprofile 関連を外す。

出力を保存してなかったから、エラーは不明だけど、エラー出た。Makefile を見ると BOOT_LDFLAGS
というのがあるから

``
make V=1 BOOT_CFLAGS='-march=native -O2 -fprofile-generate  -fprofile-arcs' \
BOOT_LDFLAGS='-lgcov' -j3
``

``
libiberty/pexecute.o differs
libiberty/getpwd.o differs
libiberty/simple-object-coff.o differs
libiberty/concat.o differs
lto-plugin/.libs/lto-plugin.o differs
make[2]: *** [Makefile:23270: compare] エラー 1
make[2]: ディレクトリ '/sources/gcc-7-20170615/build' から出ます
make[1]: *** [Makefile:23250: stage3-bubble] エラー 2
make[1]: ディレクトリ '/sources/gcc-7-20170615/build' から出ます
make: *** [Makefile:934: all] エラー 2
``

あ、なんかステージ2 と 3 でバイナリ変わっちゃってるらしい。FDO は正規の手順が良さそう。

## LTO

``
export CFLAGS='-march=native -O2'
mkdir -v build 
cd build
../configure --prefix=/opt/gcc-7-20170615-LTO \
    --disable-multilib                               \
    --with-system-zlib  --with-build-config=bootstrap-lto
make V=1 BOOT_CFLAGS='-march=native -O2'  -j3 > hoge 2>&1
``

# prefix, suffix, DESTDIR 考察

suffix 使っても、名前が変わるのは実行ファイルだけでライブラリは変わらない。そのため graft
でインストールするとき、当然 conflict が起きる。-p で pruned してしまうと、一時的に
libstdc++.so とかが消えてしまい、立ち往生する（別 OS から復元とか必要). なのでライブラリだ
けでも、自力で ln -sfv する必要がある。

やはり prefix 変えるのが一番簡単で安全なのかな。


<!-- vim: set tw=90 filetype=markdown : -->
