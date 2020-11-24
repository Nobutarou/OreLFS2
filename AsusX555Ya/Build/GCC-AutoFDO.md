# GCC で AutoFDO に挑戦

`-fprofile-generate` と `-fprofile-use` を使う最適化は浪漫だが Makefile を書き換える必要が
あったりと実用的ではない。そこで AutoFDO という、自分の好きなタイミングでプロファイルを収
集する方法に挑戦してみる

# 基本の練習

https://gcc.gnu.org/wiki/AutoFDO/Tutorial ←の例題を試す。

まず勘違いしていたが、自分の環境にいつのまにか入っている gperf は perf とは関係ない。なの
で kernel の tools/perf で make しないといけない。いくつかの依存パッケージも入れる必要があ
る。-Wno-error-hogehoge を Makefile に書き足す必要もある。make install が home ディレクト
リに配置するので /opt に起き直して graft とかしないといけない。

次に https://github.com/google/autofdo をインストールする。perf が収集する profile を gcov
に変換するツールらしい。これはこれで 1 年以上更新されてなく autoconf か autoreconf が必要
だった。-ltinfo が無いと言われたが arch aur によると ncurses 互換らしい。

``
ln -sv /usr/lib/libncursesw.so /usr/lib/libtinfo.so
``

で 良いみたい。

次に ocperf を https://github.com/andikleen/pmu-tools からインストール、というか python ス
クリプトなので /opt に置いて path に追加。

で、
``
% ocperf.py record -b -e br_inst_retired.near_taken:pp -- ./sort
Downloading https://download.01.org/perfmon/mapfile.csv to mapfile.csv
Downloading https://download.01.org/perfmon/readme.txt to readme.txt
Do not recognize CPU or cannot find CPU map file.
perf record -b -e br_inst_retired.near_taken:pp -- ./sort_baseline
event syntax error: '...near_taken:pp'
                                  \___ parser error
Run 'perf list' for a list of valid events

 Usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]

    -e, --event <event>   event selector. use 'perf list' to list available events
``

kernel なにか足りないかなって、branch profiling は overhead がすごい的なことが書いてある。
本末転倒じゃんか
<!-- vim: set tw=90 filetype=markdown : -->
