# 5.30

CFLAGS や LDFLAGS はそのままでは通ららん。

```
-Doptimize="${CFLAGS}" -Dlddlflags="-shared ${LDFLAGS}" -Dldflags="${LDFLAGS}"
``` 

archpkg より。ただし pgo は configure が通らない。もしやるなら clang に期待。

```
cc -c -DPERL_CORE -D_REENTRANT -D_GNU_SOURCE -fwrapv -fno-strict-aliasing -pipe -fstack-protector-strong -I/usr/local/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -std=c89 -O1 -fgcse -fprofile-generate=/sources/gcda/perl-5.30.1 -fprofile-arcs -Wall -Werror=declaration-after-statement -Werror=pointer-arith -Wextra -Wc++-compat -Wwrite-strings -fPIC generate_uudmap.c
cc -o generate_uudmap -lgcov -fstack-protector-strong -L/usr/local/lib generate_uudmap.o -lpthread -ldl -lm -lcrypt -lutil -lc
/usr/bin/ld: generate_uudmap.o: in function `output_to_file':
generate_uudmap.c:(.text+0x34): undefined reference to `__gcov_time_profiler_counter'
```


<!-- vim: set tw=90 filetype=markdown : -->
