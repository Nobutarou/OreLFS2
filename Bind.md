# DNS キャッシュしたい 

まずは良くわからないまま BLFS の set up に従う。
BLFS の設定は、権威サーバーだとかなんとかということろに自分で問い合わせるスタイル。

そして Archwiki, https://wiki.archlinux.org/index.php/BIND に従う。Arch は /etc/named.conf
で BLFS は /srv/named/etc/named.conf 

最初の options に listen-on と forwarders を入れる。

```
options {
    directory "/etc/named";
    pid-file "/var/run/named.pid";
    statistics-file "/var/run/named.stats";
    listen-on { 127.0.0.1; };
    forwarders { 1.1.1.1; 1.0.0.1; };
};
```

これで ```dig google.com``` すると二回目は 0秒になるし、1.1.1.1/help にアクセスすると使用中となる。

zone とか消して良い気がするが、分からないのでそのままとしておく


<!-- vim: set tw=90 filetype=markdown : -->

