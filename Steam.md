# Flatpak で使おう

マルチライブラリーを自分でビルドしなくて良い。

# kernel config

```.config
CONFIG_IA32_EMULATION=y
CONFIG_COMPAT_32BIT_TIME=y
```

# udev rule

スチームは /dev/hidrawx を見るらしいので

```/etc/udev/rules.d/71-ds4.rules
# Sony PlayStation DualShock 4; bluetooth; USB
#KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0660", TAG+="uaccess"
#KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0660", TAG+="uaccess"

# Sony PlayStation DualShock 4 Slim; bluetooth; USB
KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0660", TAG+="uaccess"
KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", GROUP="input", MODE="0660", TAG+="uaccess"

# Sony PlayStation DualShock 4 Wireless Adapter; USB
#KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0660", TAG+="uaccess"
```

# /run 以外のフォルダを使えるようにする

何もしないと ``/run/user/1000/`` 某しか使えなくて Steam で Steam 以外のゲームのインストー
ルができない。

```
flatpak override --user --filesystem=/var/games com.valvesoftware.Steam
```

などとしておく(パーミッションはもちろん必要)。
