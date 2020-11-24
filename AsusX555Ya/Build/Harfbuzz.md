# Harfbuzz-2.2.0 を Clang で PGO しようとしたら

```
libtool: link: clang++ -fno-rtti -O2 -fprofile-generate=/sources/gcda/harfbuzz-2.2.0 -fno-exceptions -fno-threadsafe-statics -Wcast-align -fvisibility-inlines-hidden -std=c++11 -fprofile-generate=/sources/gcda/harfbuzz-2.2.0 -Bsymbolic-functions -o .libs/hb-shape hb-shape.o options.o  ../src/.libs/libharfbuzz.so -lm -L/usr/lib64 -lglib-2.0 -lfreetype
/usr/bin/ld: .libs/hb-subset: hidden symbol `atexit' in /usr/lib/libc_nonshared.a(atexit.oS) is referenced by DSO
/usr/bin/ld: final link failed: Bad value
clang-7: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [Makefile:620: hb-subset] エラー 1
make[2]: *** 未完了のジョブを待っています....
libtool: link: clang++ -fno-rtti -O2 -fprofile-generate=/sources/gcda/harfbuzz-2.2.0 -fno-exceptions -fno-threadsafe-statics -Wcast-align -fvisibility-inlines-hidden -std=c++11 -fprofile-generate=/sources/gcda/harfbuzz-2.2.0 -Bsymbolic-functions -o .libs/hb-ot-shape-closure hb-ot-shape-closure.o options.o  ../src/.libs/libharfbuzz.so -lm -L/usr/lib64 -lglib-2.0 -lfreetype
make[2]: ディレクトリ '/sources/harfbuzz-2.2.0/util' から出ます
make[1]: *** [Makefile:517: all-recursive] エラー 1
make[1]: ディレクトリ '/sources/harfbuzz-2.2.0' から出ます
make: *** [Makefile:449: all] エラー 2
```

という例のやつ。


<!-- vim: set tw=90 filetype=markdown : -->
