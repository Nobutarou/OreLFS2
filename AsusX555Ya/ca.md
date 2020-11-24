# Firefox で google の接続が安全じゃなくなって接続できなくなる

BLFS-20170506 の Certificate Authority Certificates が BLFS-7.8 のときと違い、
/etc/ssl/certs/ca-certificates.crt を作らなくなっている。

```
cd /etc/ssl/certs
ln -sv ../ca-bundle.crt ./ca-certificates.crt
```

で大丈夫。ただ更新するたびにリンクを消してしまうようなので注意。

<!-- vim: set tw=90 filetype=markdown : -->
