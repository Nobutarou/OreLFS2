# Python2 の FDO ビルド


Firefox の FDO に Python2 での Sqlite3 モジュールが必要になるようだ（もしかすると Python3
かもしれない)

PKGBUILD によると

``
  sed -i "/SQLITE_OMIT_LOAD_EXTENSION/d" setup.py
``

しないと有効にならないようだ。

## 一回目の挑戦

それから ./configure --help によると FDO, LTO の際は

``
--enable-optimizations
``

が必要らしい。で make -j3 してみると、あー -O2 で十分なのに -O3 で上書きしやがる。

そして、一回目のビルドが終ったら

``
make -k test -j3
``

で gcda を得る。幾つかエラーが出てるが放置しておく。root で

``
find -name '*.gcda' -exec chattr +i {} \;
``

してから, フォルダごと rm. 警告は出るが gcda 以外は消える。そして二回目のビルドすると、こ
んなメッセージが大量に出る。


``
profiling:/sources/Python-2.7.13/Modules/xxsubtype.gcda:Cannot open
``

うーん, chattr -i してから make すると初期ステージで消される。

## 二回目の挑戦

--enable-optimizations 自体が FDO, LTO を有効にするものらしいので、それを信じて

``
CFLAGS='-march=native -O2'
``

だけでやってみる (-O2 は -O3 に上書きされるが). 確かに -fprofile-generate あたりが付いてい
るし、しばらくすると -fprofile-use や -flto が付いていた。

なるほど、へんなことしなくて良いのか。

<!-- vim: set tw=90 filetype=markdown : -->
