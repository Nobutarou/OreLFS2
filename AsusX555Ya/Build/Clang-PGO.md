# Clang で PGO するやりかた

```
CC=clang
CXX=clang++
CFLAGS=-O2 -fprofile-generate=/sources/gcda/Build
CXXFLAGS=-O2 -fprofile-generate=/sources/gcda/Build
LDFLAGS=-fprofile-generate=/sources/gcda/Build
LIBS=
```

のように一回目ビルドして、テストなりなにかしてプロファイルを作る。

```
cd /sources/gcda/Build
llvm-profdata merge -output=default.profdata default_*.profraw  
```

として、プロファイルをまとめる。

```
CFLAGS=-O2 -fprofile-use=/sources/gcda/Build -march=native
CXXFLAGS=-O2 -fprofile-use=/sources/gcda/Build -march=native
LDFLAGS=
LIBS=
```

のように二回目でそのプロファイルを使う。このときに一回目に付けていなかった march とか flto も付けられる。

<!-- vim: set tw=90 filetype=markdown : -->
