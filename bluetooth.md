# 接続デバイスがなくなると勝手に bluetooth.service が止まる

``systemctl edit bluetooth.service`` にて

```
[Service]
Restart=always
```


<!-- vim: set tw=90 filetype=markdown : -->

