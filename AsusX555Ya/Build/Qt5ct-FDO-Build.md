# Qt5ct の FDO ビルド

``
qmake-qt5 qt5ct.pro
``

で Makefile を作らないといけないのだけど、Qt をビルドしたときかなにかの CFLAGS に強制され
てしまう。make した直後に出きる Makefile を手修正して、そのあと make clean && make とする
必要がある。

<!-- vim: set tw=90 filetype=markdown : -->
