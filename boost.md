# DESTDIR

```
./b2 --prefix=$DESTDIR$PREFIX install  threading=multi link=shared
```

しかし、PREFIX=/usr で graft でインストールしても、実際には BOOSTROOT 環境変数を設定しなくてはならない。


<!-- vim: set tw=90 filetype=markdown : -->
