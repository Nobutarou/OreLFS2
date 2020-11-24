# Sytemd の boot を速くする

## 分析

```
systemd-analyze plot > hoge.svg
```

で分析。svg は firefox があれば見れる。

ちなみに並列起動してるから、一つ一つが速くなっても、全体では変わらなかったりする。

## systemd-jounald.service

最初数秒かかってた気がする。

/etc/systemd/journald.conf

```
SystemMaxUse=30M
RuntimeMaxUse=30M
```

として、小さくする。どうせ分析する能力ないんだし。

```
journalctl --vacuum-size=30M
journalctl --vacuum-time=1weeks
```

で小さくしておく。

これで 1sec 切る。

## systemd-fsck-root.service

2, 3 秒掛かってた気がする。

```
# fsck する気がないなら OK
systemctl mask systemd-fsck-root.service
```

どうせ壊れるときは一気にくるだろ。また、別パーティションから起動して fsck を掛けても良いわ
けだ

## systemd-remount-fs.service

これ自身は 1.5s、おそらくこれがキックしてる dev-sda6.device が 3s 掛かるけど、どうにもでき
なかった

systemd-remount-fs.service を無効にする方法が
https://wiki.archlinux.jp/index.php/%E3%83%96%E3%83%BC%E3%83%88%E3%83%91%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%B3%E3%82%B9%E3%81%AE%E5%90%91%E4%B8%8A
に書いてあるけど、どうもブートできないので、今のところあきらめ

## systemd-random-seed.service

2, 3sec 掛かってた。boot オプションに 

```
random.trust_cpu=on
```

にすると 0.07sec. カーネルコンフィグ時に有効にしておいても良いかも
