# uim 

## uim-xim
不要。xterm とか使わないし。むしろ firefox でキーリピートしないという問題が出た。

```
/usr/bin/gtk-query-immodules-2.0 --update-cache 
/usr/bin/gtk-query-immodules-3.0 --update-cache 
```

これで /usr/lib/gtk-2.0/2.10.0/immodules.cache と /usr/lib/gtk-3.0/3.0.0/immodules.cache
が更新される。


## ロケールの問題

/etc/locale.conf に従って

```zsh
export LANG=ja_JP.UTF-8
```

ほとんどのプログラムが utf8 とか UTF8 とか utf-8 とかで動いているんだけど、uim は特別に気
を付ける必要がある

<!-- vim: set tw=90 filetype=markdown : -->

