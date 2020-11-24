# Udev のデバイス名を固定する方法 

## NIC

モバイル wifi を USB 経由で使うので、どのデバイス差しても eth0 とかになってほしい。

```zsh
cat > /etc/udev/rules.d/99-wx2.rules <<EOF
SUBSYSTEM=="net",  ATTR{address}=="c0:25:a2:e9:95:69", NAME="eth0"
EOF
```

というように MAC アドレスで指定している。なお、複数の LAN を使うことはないので、これで問題
ない。

ところで SUBSYSTEM=="net" かつ SUBSYSTEM=="usb" なら、eth0 というようにできれば、汎用的だ
と思うけど、良くわからないから放置。

SUBSUSTEM とか ATTR は

```zsh
udevadm info -a -p /sys/class/net/enphogehoge
```

で見る。enphogehoge は dmesg でも良いけど、変な名前だから、フォルダ覗けば分かると思う。

###


<!-- vim: set tw=90 filetype=markdown : -->

