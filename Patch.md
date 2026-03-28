# Patch の使いかた
## Hunk #n Failed

try adding --ignore-whitespace

## BLFS で良く使うオプション

- -N  間違って二回当ててしまっても、元に戻さない
- -p1 diff に書かれているパスの先頭を飛ばす
- -i  diff ファイルを使う

## xz で圧縮されている diff ファイルのとき

``
unxz -c ../hogehoge.diff.xz | pathc -Np1
``

と使う。

<!-- vim: set tw=90 filetype=markdown : -->

