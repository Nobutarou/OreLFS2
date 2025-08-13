# 注意事項

CMOS クリアなどで時刻がずれると、動かなくなる。多分先方で拒否してるんだと思う。

1. 一旦 /etc/resolv.conf を 1.1.1.1 などで直書きにする。
1. 時刻を合わせる
1. /etc/resolv.conf を元に戻す (127.0.0.1)

時刻合わせは

```
sudo sntp -Ss ntp.nict.jp
sudo hwclock --systohc
```
