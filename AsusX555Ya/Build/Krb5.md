# 1.18

clang は PGO 一回目で

```
make[2]: *** 'libcom_err.so.3.0' に必要なターゲット '../../lib/libkrb5support.so' を make するルール
がありません.  中止.
make[2]: ディレクトリ '/sources/krb5-1.18/src/util/et' から出ます
make[1]: *** [Makefile:888: check-recurse] エラー 1
make[1]: ディレクトリ '/sources/krb5-1.18/src/util' から出ます
make: *** [Makefile:1546: check-recurse] エラー 1
``` 

いや、普通の cflags でもそうなる

gcc は PGO 二回目で同じエラー

ん、なんか変だ。make -j4 だとエラーになるのかな？

あ、-j1 しか動かなかっただけらしい

<!-- vim: set tw=90 filetype=markdown : -->
