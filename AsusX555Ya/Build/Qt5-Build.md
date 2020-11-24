# Guideline
Qt5 doesn't see CFLAGS. It forces to use gcc and O3. I am tired to fight to them. I choose
no-touch.


# DESTDIR ではなく INSTALL_ROOT
# clang でやってみる

```
./configure -platform linux-clang
```

qtbase/mkspecs/common/gcc-base.conf を書き換える。

```
qjson.cpp:(.text._ZN12QJsonPrivate4Data7compactEv+0x400):
`__llvm_profile_instrument_range' に対する定義されていない参照です
qjson.cpp:(.text._ZN12QJsonPrivate4Data7compactEv+0x521):
`__llvm_profile_instrument_range' に対する定義されていない参照です
qjson.cpp:(.text._ZN12QJsonPrivate4Data7compactEv+0x614):
`__llvm_profile_instrument_range' に対する定義されていない参照です
/sources/qt-everywhere-src-5.14.1/qtbase/lib/libQt5Bootstrap.a(qjson.o): 関数
`QJsonPrivate::Base::reserveSpace(unsigned int, int, unsigned int, bool)' 内:
qjson.cpp:(.text._ZN12QJsonPrivate4Base12reserveSpaceEjijb+0x80):
`__llvm_profile_instrument_range' に対する定義されていない参照です
/sources/qt-everywhere-src-5.14.1/qtbase/lib/libQt5Bootstrap.a(qjson.o):qjson.cpp:(.text._ZN12QJsonPrivate4Base12reserveSpaceEjijb+0xe3):
`__llvm_profile_instrument_range' に対する定義されていない参照がさらに続いています
clang-9: error: linker command failed with exit code 1 (use -v to see invocation)
make[3]: *** [Makefile:140: ../../../bin/moc] エラー 1
make[3]: ディレクトリ '/sources/qt-everywhere-src-5.14.1/qtbase/src/tools/moc' から出ます
make[2]: *** [Makefile:96: sub-moc-make_first] エラー 2
make[2]: ディレクトリ '/sources/qt-everywhere-src-5.14.1/qtbase/src' から出ます
make[1]: *** [Makefile:51: sub-src-make_first] エラー 2
make[1]: ディレクトリ '/sources/qt-everywhere-src-5.14.1/qtbase' から出ます
make: *** [Makefile:87: module-qtbase-make_first] エラー 2
```

無理なやつだ。そもそもすごいビルド時間だから PGO のメリット少ない


# clang の通し方

QMAKE_CC, QMAKE_CXX で指定できないので分からない。

これかな？
https://doc.qt.io/qt-5/configure-options.html 

```
./configure -platform linux-clang
./configure -platform linux-g++
```

まだ確かめてはいない。

# Qt-5 の FDO ビルドに挑戦

## コンパイル初回

CFLAGS, LDFLAGS を読みこまないので, qtbase/mkspecs/common/gcc-base.conf と linux-conf を書
きかえる。もしかしたら、そこの変数名を環境変数にすれば良いのかもしれないけど Arch の
PKGBUILD も sed で書き換えてるので、ま、良いでしょう。

``diff
--- qt-everywhere-opensource-src-5.9.0/qtbase/mkspecs/common/linux.conf.org	2017-06-01 13:35:45.730445540 +0900
+++ qt-everywhere-opensource-src-5.9.0/qtbase/mkspecs/common/linux.conf	2017-06-01 13:36:03.390445493 +0900
@@ -26,7 +26,7 @@
 QMAKE_INCDIR_OPENVG     =
 QMAKE_LIBDIR_OPENVG     =
 
-QMAKE_LIBS              =
+QMAKE_LIBS              = -lgcov
 QMAKE_LIBS_DYNLOAD      = -ldl
 QMAKE_LIBS_X11          = -lXext -lX11 -lm
 QMAKE_LIBS_NIS          = -lnsl
--- qt-everywhere-opensource-src-5.9.0/qtbase/mkspecs/common/gcc-base.conf.org	2017-06-01 21:59:19.300477724 +0900
+++ qt-everywhere-opensource-src-5.9.0/qtbase/mkspecs/common/gcc-base.conf	2017-06-01 13:54:06.000442581 +0900
@@ -31,8 +31,8 @@
 # you can use the manual test in tests/manual/mkspecs.
 #
 
-QMAKE_CFLAGS_OPTIMIZE      = -O2
-QMAKE_CFLAGS_OPTIMIZE_FULL = -O3
+QMAKE_CFLAGS_OPTIMIZE      = -march=native -O2 -fprofile-generate -fprofile-arcs 
+QMAKE_CFLAGS_OPTIMIZE_FULL = -march=native -O2 -fprofile-generate -fprofile-arcs 
 QMAKE_CFLAGS_OPTIMIZE_DEBUG = -Og
 QMAKE_CFLAGS_OPTIMIZE_SIZE = -Os
``

prefix は /opt 以下にして、初回と二度目の場所も変えることにする。

``zsh
./configure -prefix /opt/qt-5.9.0-PreFDO \
            -confirm-license           \
            -opensource                \
            -dbus-linked               \
            -openssl-linked            \
            -system-harfbuzz           \
            -system-sqlite             \
            -nomake examples           \
            -no-rpath                  \
            -skip qtwebengine
`` 

## 二回目のビルド

適当に Vlc とか KeepassX とか動かしたら二回目に。

``diff
--- qt-everywhere-opensource-src-5.9.0/qtbase/mkspecs/common/gcc-base.conf.org	2017-06-01 21:59:19.300477724 +0900
+++ qt-everywhere-opensource-src-5.9.0/qtbase/mkspecs/common/gcc-base.conf	2017-06-01 13:54:06.000442581 +0900
@@ -31,8 +31,8 @@
 # you can use the manual test in tests/manual/mkspecs.
 #
 
-QMAKE_CFLAGS_OPTIMIZE      = -O2
-QMAKE_CFLAGS_OPTIMIZE_FULL = -O3
+QMAKE_CFLAGS_OPTIMIZE      = -march=native -O2 -fprofile-use -fprofile-correction
+QMAKE_CFLAGS_OPTIMIZE_FULL = -march=native -O2 -fprofile-use -fprofile-correction
 QMAKE_CFLAGS_OPTIMIZE_DEBUG = -Og
 QMAKE_CFLAGS_OPTIMIZE_SIZE = -Os
``

``zsh
./configure -prefix /opt/qt-5.9.0-FDO \
            -confirm-license           \
            -opensource                \
            -dbus-linked               \
            -openssl-linked            \
            -system-harfbuzz           \
            -system-sqlite             \
            -nomake examples           \
            -no-rpath                  \
            -skip qtwebengine
`` 

このときに設定した CFLAGS がシステム設定になってしまう。探すの面倒だし、それほど QT アプリ
を使うわけじゃないので FDO しなくて良いかな。

<!-- vim: set tw=90 filetype=markdown : -->
