# なんとか PGO できた

``
CFLAGS=-march=native -O2 -ftree-vectorize -fprofile-generate=/sources/gcda -fprofile-arcs -pipe
``

でやると make check でエラーなので、make 終了後

``
CFLAGS=-march=native -O2 -ftree-vectorize -pipe
``

とかしてもう一度 ./configure してから make check

# LTO (OBSO)
make check で

``
../../test-driver: 107 行: 20189 中止                  (コアダンプ) "$@" > $log_file 2>&1
FAIL: t-get_d_2exp
``

ar, ranlib, nm に変えて gcc-ar, gcc-ranlib, gcc-nm 使ったけど落ちた。つまり LTO 使うとだめ
みたい。

ところで gcc-7 を /opt/ にインストールしたため、/usr/lib/bfd-plugins/liblto_plugin.so が、
LFS ビルド時の gcc-6.2 の物になっていることが判明。リンク貼り直すだけで良いのかな。

<!-- vim: set tw=90 filetype=markdown : -->
