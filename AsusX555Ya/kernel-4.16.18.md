# Kernel-4.16.18 メモ

## wifi や bluetooth の警告がコンソールに流れてくる

これまでは ``/etc/sysctl.d/printk.conf`` に

```
kernel.printk = 3 4 1 3
```

で良かったんだが、このバージョンから、これを読んでくれない。``sysctl -a`` で調べると ``15
4 1 3`` の用になる。

起動時のカーネルオプション ``loglevel=3`` で回避できた。

<!-- vim: set tw=90 filetype=markdown : -->
