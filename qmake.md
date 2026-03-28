# qmake

## QT ビルド時の CFLAGS が消えない

``
/opt/qt5/mkspecs/common/gcc-base.conf
``

とかを書き換えれば良い。

## CFLAGS とかは

QMAKE_CFLAGS, QMAKE_CXXFLAGS, QMAKE_LDFLAGS あたり。QMAKE_LIBS は効果ないみたい。

<!-- vim: set tw=90 filetype=markdown : -->

