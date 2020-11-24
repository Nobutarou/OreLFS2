# CD-ROM のスピードを変える。

``
eject -x 8
``

とかで変更できるのだけど、なぜか一度アクセスが消えると最大値 24 に復帰するので

``
watch -n 1 ejext -x 8
``

とかする。watch をそんな使い方するなよと思う。

<!-- vim: set tw=90 filetype=markdown : -->
