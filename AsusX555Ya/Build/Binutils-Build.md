# DESTDIR とプラグインパス

/usr/lib/bfd-plugins ではなくて $DESTDIR/usr/lib/bfd-plugins を読みにいくので注意
。

```
cd $DESTDIR/usr/lib
install -dv bfd-plugins
cd bfd-plugins
ln -sv /usr/lib/bfd-plugins/liblto_plugin.so ./
```

# PGO は？

一回目は test せずにインストール。何かやってれば、binutils は必ず使われるので、その後で二
回目。しかし二回目も test は失敗するのであきらめた。

# LTO は？

make check でこんなエラーが出てくる。↓のは無理矢理 -fuse-linker-plugin 入れてみたけど、順
番てきに駄目か。

まああきらめよう。

``
fmerge-constants -O2 -fuse-linker-plugin -fno-use-linker-plugin   -o object_unittest | sed -e 's/-Wp,-D_FORTIFY_SOURCE=[0-9][0-9]*//'` object_unittest.o libgoldtest.a ../libgold.a ../../libiberty/libiberty.a   -ldl -L../../zlib -lz -ldl
/usr/bin/ld: fileread.o: plugin needed to handle lto object
/usr/bin/ld: gold.o: plugin needed to handle lto object
/usr/bin/ld: object.o: plugin needed to handle lto object
/usr/bin/ld: options.o: plugin needed to handle lto object
/usr/bin/ld: parameters.o: plugin needed to handle lto object
/usr/bin/ld: script.o: plugin needed to handle lto object
/usr/bin/ld: target.o: plugin needed to handle lto object
/usr/bin/ld: target-select.o: plugin needed to handle lto object
object_unittest.o: 関数 `gold_testsuite::Object_test(gold_testsuite::Test_report*)' 内:
object_unittest.cc:(.text+0xc): `gold::General_options::General_options()' に対する定義されていない参 照です
object_unittest.cc:(.text+0x14): `gold::set_parameters_options(gold::General_options const*)' に対する定義されていない参照です
object_unittest.cc:(.text+0x31): `gold::parameters' に対する定義されていない参照です
object_unittest.cc:(.text+0x79): `gold::parameters' に対する定義されていない参照です
object_unittest.cc:(.text+0xc4): `gold::parameters' に対する定義されていない参照です
object_unittest.cc:(.text+0x10f): `gold::parameters' に対する定義されていない参照です
object_unittest.cc:(.text+0x167): `gold::do_gold_unreachable(char const*, int, char const*)' に対する 定義されていない参照です
object_unittest.cc:(.text+0x18e): `gold::do_gold_unreachable(char const*, int, char const*)' に対する 定義されていない参照です
object_unittest.cc:(.text+0x1a2): `gold::do_gold_unreachable(char const*, int, char const*)' に対する 定義されていない参照です
object_unittest.cc:(.text+0x1b6): `gold::do_gold_unreachable(char const*, int, char const*)' に対する 定義されていない参照です
``



<!-- vim: set tw=90 filetype=markdown : -->
