# 書き込めない

Uno R4 の挙動として、普段は /dev/ttyACM0 として端末として動作するが、書き込み中だけ、何か
別のデバイスとして動作している。ArchWiki には uucp グループに追加しろと書いてあり、
/dev/ttyACM0 はuucp グループが当っているのは確認できるが、書き込み中デバイスは、何か別のグ
ループのようである。書き込みがすぐ終るので、自分には認識ができない。

/etc/udev/rules.d/52-ArduinoUnoR4_fix.rules

```
SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0069", GROUP="users"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0369", GROUP="users"
```

0069 は ttyACM0. 0369 が書き込み中の何か。別に自分しかユーザーいないし、Arduino くらい誰が
使えても良いので、users にしておいた

<!-- vim: set tw=90 filetype=markdown : -->

