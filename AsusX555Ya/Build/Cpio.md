# 2.13

Clang PGO できなかった。

```
CC=clang
CXX=clang++
CFLAGS=-O2 -fprofile-generate=/sources/gcda/cpio-2.13
CXXFLAGS=-O2 -fprofile-generate=/sources/gcda/cpio-2.13
LDFLAGS=-fprofile-generate=/sources/gcda/cpio-2.13
LIBS=
```

```
clang  -O2 -fprofile-generate=/sources/gcda/cpio-2.13   -fprofile-generate=/sources/gcda/cpio-2.13  -o mt mt.o ../lib/libpax.a ../gnu/libgnu.a
../gnu/libgnu.a(xmalloc.o): 関数 `xnmalloc' 内:
xmalloc.c:(.text+0x1d): `__muloti4' に対する定義されていない参照です
../gnu/libgnu.a(xmalloc.o): 関数 `xnrealloc' 内:
xmalloc.c:(.text+0xf0): `__muloti4' に対する定義されていない参照です
../gnu/libgnu.a(xmalloc.o): 関数 `xcalloc' 内:
xmalloc.c:(.text+0x3ed): `__muloti4' に対する定義されていない参照です
clang-9: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [Makefile:1280: mt] エラー 1
```

gcc はできそう

<!-- vim: set tw=90 filetype=markdown : -->
