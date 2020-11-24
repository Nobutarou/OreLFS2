# libabw-0.1.1 の FDO ビルド

通常なら LibreOffice ビルド時に勝手にダウンロードされてビルドされるものだけど、手作業でや
ってみる。

## コンパイル初回

boost への -l がリンカオプションに付けてくれずにエラーとなるので
``
export LDFLAGS='-lgcov -lboost_system'
``

make check が何もしないし、Abiword も入れてないのでバイナリの実行もできない。二回目のビル
ドはいつになるかな

##

<!-- vim: set tw=90 filetype=markdown : -->
