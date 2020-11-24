# まとめ

- 既存のバージョンアップは絶対やるな
- PGO  は 2.31 では無理
- rm /usr/include/limits.h は必須。

# 2.31

PGO 一回目の configure の conftest でエラーになる。-O1 とかで通しておいて config.make を書
きかえるとある程度進むが、

```
gcc -ffile-prefix-map=/tools=/usr -lgcov  -nostdlib -nostartfiles -shared -o /sources/glibc-2.31/build/elf/ld.so.new            \
          -Wl,-z,combreloc -Wl,-z,relro -Wl,--hash-style=both -Wl,-z,defs       \
          /sources/glibc-2.31/build/elf/librtld.os -Wl,--version-script=/sources/glibc-2.31/build/ld.map                \
          -Wl,-soname=ld-linux-x86-64.so.2                      \
          -Wl,-defsym=_begin=0
/tools/lib/gcc/x86_64-pc-linux-gnu/9.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: /sources/glibc-2.31/build/elf/librtld.os: in function `security_init':
rtld.c:(.text+0x5c): undefined reference to `__gcov_time_profiler_counter'
/tools/lib/gcc/x86_64-pc-linux-gnu/9.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: /sources/glibc-2.31
```

で configure に --enable-profile とあったので入れても同じ。glibc の pgo はやはり今のところあきらめよう

# PGO は configure で error

``
CFLAGS=-march=native -O2 -ftree-vectorize -fprofile-generate=/sources/gcda -fprofile-arcs -pipe
CXXFLAGS=-march=native -O2 -ftree-vectorize -fprofile-generate=/sources/gcda -fprofile-arcs -pipe
LDFLAGS=-lgcov
LIBS=-lgcov
``

で

``
 ../configure --prefix=/usr --disable-werror --enable-stack-protector=strong \
   libc_cv_slibdir=/lib
``

すると

``
checking for broken __attribute__((alias()))... no
checking whether to put _rtld_local into .sdata section... no
checking whether to use .ctors/.dtors header and trailer... configure: error: missing __attribute__ ((constructor)) support??
``

で落ちる。どうにもできない。

# LTO

``
/opt/gcc-7/bin/gcc -isystem /opt/gcc-7/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include -isystem /usr/include ../sysdeps/unix/sysv/linux/x86_64/setcontext.S -c     -I../include -I/sources/glibc-2.27/glibc-2.27/stdlib  -I/sources/glibc-2.27/glibc-2.27  -I../sysdeps/unix/sysv/linux/x86_64/64  -I../sysdeps/unix/sysv/linux/x86_64  -I../sysdeps/unix/sysv/linux/x86  -I../sysdeps/x86/nptl  -I../sysdeps/unix/sysv/linux/wordsize-64  -I../sysdeps/x86_64/nptl  -I../sysdeps/unix/sysv/linux/include -I../sysdeps/unix/sysv/linux  -I../sysdeps/nptl  -I../sysdeps/pthread  -I../sysdeps/gnu  -I../sysdeps/unix/inet  -I../sysdeps/unix/sysv  -I../sysdeps/unix/x86_64  -I../sysdeps/unix  -I../sysdeps/posix  -I../sysdeps/x86_64/64  -I../sysdeps/x86_64/fpu/multiarch  -I../sysdeps/x86_64/fpu  -I../sysdeps/x86/fpu/include -I../sysdeps/x86/fpu  -I../sysdeps/x86_64/multiarch  -I../sysdeps/x86_64  -I../sysdeps/x86  -I../sysdeps/ieee754/float128  -I../sysdeps/ieee754/ldbl-96/include -I../sysdeps/ieee754/ldbl-96  -I../sysdeps/ieee754/dbl-64/wordsize-64  -I../sysdeps/ieee754/dbl-64  -I../sysdeps/ieee754/flt-32  -I../sysdeps/wordsize-64  -I../sysdeps/ieee754  -I../sysdeps/generic  -I.. -I../libio -I.   -D_LIBC_REENTRANT -include /sources/glibc-2.27/glibc-2.27/libc-modules.h -DMODULE_NAME=libc -include ../include/libc-symbols.h       -DTOP_NAMESPACE=glibc -DASSEMBLER   -Werror=undef -Wa,--noexecstack   -o /sources/glibc-2.27/glibc-2.27/stdlib/setcontext.o -MD -MP -MF /sources/glibc-2.27/glibc-2.27/stdlib/setcontext.o.dt -MT /sources/glibc-2.27/glibc-2.27/stdlib/setcontext.o
../sysdeps/unix/sysv/linux/x86_64/getcontext.S:71:5: エラー: "SIG_BLOCK" is not defined, evaluates to0 [-Werror=undef]
 #if SIG_BLOCK == 0
     ^~~~~~~~~
cc1: some warnings being treated as errors
make[2]: *** [/sources/glibc-2.27/glibc-2.27/sysd-rules:41: /sources/glibc-2.27/glibc-2.27/stdlib/getcontext.o] エラー 1
make[2]: *** 未完了のジョブを待っています....
../sysdeps/unix/sysv/linux/x86_64/setcontext.S: Assembler messages:
../sysdeps/unix/sysv/linux/x86_64/setcontext.S:62: Error: bad or irreducible absolute expression
../sysdeps/unix/sysv/linux/x86_64/setcontext.S:63: Error: bad or irreducible absolute expression
../sysdeps/unix/sysv/linux/x86_64/setcontext.S:64: Error: bad or irreducible absolute expression
../sysdeps/unix/sysv/linux/x86_64/setcontext.S:65: Error: bad or irreducible absolute expression
../sysdeps/unix/sysv/linux/x86_64/setcontext.S:66: Error: bad or irreducible absolute expression
../sysdeps/unix/sysv/linux/x86_64/setcontext.S:67: Error: bad or irreducible absolute expression
../sysdeps/unix/sysv/linux/x86_64/setcontext.S:68: Error: bad or irreducible absolute expression
../sysdeps/unix/sysv/linux/x86_64/setcontext.S:69: Error: bad or irreducible absolute expression
make[2]: *** [/sources/glibc-2.27/glibc-2.27/sysd-rules:41: /sources/glibc-2.27/glibc-2.27/stdlib/setcontext.o] エラー 1
make[2]: ディレクトリ '/sources/glibc-2.27/stdlib' から出ます
make[1]: *** [Makefile:215: stdlib/subdir_lib] エラー 2
make[1]: ディレクトリ '/sources/glibc-2.27' から出ます
make: *** [Makefile:9: all] エラー 2
``

うーん。

# lto, pgo なしでも

``
GCC_INCDIR=/opt/gcc-7/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include
CC="/opt/gcc-7/bin/gcc -isystem $GCC_INCDIR -isystem /usr/include" \
../configure --prefix=/usr --disable-werror --enable-stack-protector=strong \
  libc_cv_slibdir=/lib
``
LFS book みたいに古いカーネルサポートしなくて良いでしょう。

``
make[2]: ディレクトリ '/sources/glibc-2.27/iconv' に入ります
/usr/bin/install -c -m 644 ../include/limits.h /usr/include/limits.h
/usr/bin/install: '/usr/include/limits.h' を削除できません: 許可がありません
make[2]: *** [../Makerules:1305: /usr/include/limits.h] エラー 1
``
なんで？

あ、これは /usr/include/limits.h を configure 前に rm してなかったからだ。これ必須っぽい

# graft
まじやばい。既存を消すために graft -p で、既存のファイル名を全て変えないと行けないが、その
瞬間になんのコマンドも効かなくなる。

<!-- vim: set tw=90 filetype=markdown : -->
