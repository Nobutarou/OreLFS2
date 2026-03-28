# 1.3.3

clang pgo 1st build falis.


```
libtool: link: clang++ -O2 -fprofile-generate=/sources/gcda/flac-1.3.3
-fprofile-generate=/sources/gcda/flac-1.3.3 -o .libs/example_cpp_decode_file main.o
../../../../src/libFLAC++/.libs/libFLAC++.so ../../../../src/libFLAC/.libs/libFLAC.so
-L/usr/lib -logg -lm
/usr/bin/ld: .libs/example_cpp_decode_file: hidden symbol `atexit' in
/usr/lib/libc_nonshared.a(atexit.oS) is referenced by DSO
/usr/bin/ld: final link failed: bad value
clang-10: error: linker command failed with exit code 1 (use -v to see invocation)
```


<!-- vim: set tw=90 filetype=markdown : -->
