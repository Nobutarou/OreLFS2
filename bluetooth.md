# 突然デバイスが亡くなる

```
Bluetooth: hci0: Reading Intel version command failed (-110)
Bluetooth: hci0: command 0xfc05 tx timeout
```

ググると原因不明だけど、windows を一旦起動して、きっちりパワーオフして、もう一度 Linux に
帰ると直るということで、自分も直った。

今はディスクを分けてるんだけど、デュアルブートは危険だからやめようと、改めて思った。

# 接続デバイスがなくなると勝手に bluetooth.service が止まる

``systemctl edit bluetooth.service`` にて

```
[Service]
Restart=always
```


<!-- vim: set tw=90 filetype=markdown : -->

