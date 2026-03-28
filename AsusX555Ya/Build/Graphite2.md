# 1.3.12, Clang で PGO できなかった

```
/usr/bin/ld: features: 隠されたシンボル `atexit' (/usr/lib/libc_nonshared.a(atexit.oS) 内) は DSO によって参照されています
/usr/bin/ld: 最終リンクに失敗しました: 不正な値です
clang-7: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [tests/examples/CMakeFiles/features.dir/build.make:96: tests/examples/features] エラー 1
make[1]: *** [CMakeFiles/Makefile2:385: tests/examples/CMakeFiles/features.dir/all] エラー 2
```

良く分からない atexit のやつだ。あきらめ 


<!-- vim: set tw=90 filetype=markdown : -->
