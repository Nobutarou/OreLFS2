# 1.1.1

clang でビルドすると

```
libtool: link: clang -Wall -Wno-parentheses -O3 -fforce-addr -fomit-frame-pointer -finline-functions -funroll-loops -O2 -fprofile-generate=/sources/gcda/libtheora-1.1.1 -fprofile-generate=/sources/gcda/libtheora-1.1.1 -o .libs/player_example player_example-player_example.o -Wl,-rpath -Wl,/usr/lib  ../lib/.libs/libtheoradec.so -logg -L/usr/lib -lSDL -lpthread -lvorbis
/usr/bin/ld: player_example-player_example.o: undefined reference to symbol 'rintf@@GLIBC_2.2.5'
/lib/libm.so.6: error adding symbols: DSO missing from command line
clang-9: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [Makefile:287: player_example] エラー 1
make[2]: *** 未完了のジョブを待っています....
make[2]: ディレクトリ '/sources/libtheora-1.1.1/examples' から出ます
make[1]: *** [Makefile:291: all-recursive] エラー 1
make[1]: ディレクトリ '/sources/libtheora-1.1.1' から出ます
make: *** [Makefile:205: all] エラー 2
```

分からない。 


<!-- vim: set tw=90 filetype=markdown : -->
