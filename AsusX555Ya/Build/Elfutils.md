# 0.175 with clang

arch の PKGBUILD にしたがうが、

```
configure: error: gcc with GNU99 support required
```

```
CFLAGS+=" -std=gnu99" 
```
しても同じエラー. config.log を覗くと

```
configure:5027: checking for gcc with GNU99 support
configure:5052: clang -c -O2 -fprofile-generate=/sources/gcda/elfutils-0.175 -g -std=gnu99  -std=gnu99
  conftest.c >&5
conftest.c:20:28: error: function definition is not allowed here
  double square (double z) { return z * z; }
                           ^
conftest.c:21:10: warning: implicit declaration of function 'square' is invalid in C99 [-Wimplicit-fun
ction-declaration]
  return square (a) + square (b);
         ^
conftest.c:26:18: error: fields must have a constant size: 'variable length array in structure' extens
ion will never be supported
  struct S { int x[n]; };
                 ^
1 warning and 2 errors generated.
```

なんか GNU99 はこれを許してなくて gcc の拡張らしいし、clang はそういうのきらいみたいだから、これはどうにもならないやつだ。

# LTO is not available

``zsh
/tmp/ccJOAChd.ltrans0.ltrans.o:(*IND*+0x0): multiple definition of `dwarf_bytesize'
dwarf_bytesize.os (symbol from plugin):(.text+0x0): first defined here
/tmp/ccJOAChd.ltrans0.ltrans.o:(*IND*+0x0): multiple definition of `dwarf_arrayorder'
dwarf_arrayorder.os (symbol from plugin):(.text+0x0): first defined here
/tmp/ccJOAChd.ltrans0.ltrans.o:(*IND*+0x0): multiple definition of `dwarf_bitsize'
dwarf_bitsize.os (symbol from plugin):(.text+0x0): first defined here
/tmp/ccJOAChd.ltrans0.ltrans.o:(*IND*+0x0): multiple definition of `dwarf_bitoffset'
dwarf_bitoffset.os (symbol from plugin):(.text+0x0): first defined here
/tmp/ccJOAChd.ltrans0.ltrans.o:(*IND*+0x0): multiple definition of `dwarf_srclang'
dwarf_srclang.os (symbol from plugin):(.text+0x0): first defined here
/tmp/ccJOAChd.ltrans0.ltrans.o:(*IND*+0x0): multiple definition of `dwarf_decl_file'
dwarf_decl_file.os (symbol from plugin):(.text+0x0): first defined here
/tmp/ccJOAChd.ltrans0.ltrans.o:(*IND*+0x0): multiple definition of `dwarf_decl_line'
dwarf_decl_line.os (symbol from plugin):(.text+0x0): first defined here
/tmp/ccJOAChd.ltrans0.ltrans.o:(*IND*+0x0): multiple definition of `dwarf_decl_column'
dwarf_decl_column.os (symbol from plugin):(.text+0x0): first defined here
/usr/bin/ld: libdw.so: No symbol version section for versioned symbol `dwarf_aggregate_size@ELFUTILS_0.161'
/usr/bin/ld: final link failed: Nonrepresentable section on output
collect2: error: ld returned 1 exit status
make[3]: *** [Makefile:1010: libdw.so] Error 1
make[2]: *** [Makefile:514: all] Error 2
make[1]: *** [Makefile:481: all-recursive] Error 1
make: *** [Makefile:397: all] Error 2
``


<!-- vim: set tw=90 filetype=markdown : -->
