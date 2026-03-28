# nmcli

zsh のタブ補完が効く

```
# スキャン
nmcli device wifi rescan
nmcli device wifi list
```

```
# 接続
nmcli device wifi connect [SSID] password [PASSWORD]
```

一回、上記の方法で接続すると、保存される。

```
# 保存ずみの接続設定一覧
nmcli connection show

# 切る
nmcli connection [Name] down

# 繋ぐ
nmcli connection [Name] up
```

あ、sudo 忘れ

# 中継器 WEX-733DHP

Windows10 でしょっちゅう切れるので固定 IP にしたらそこそこ安定。Linux でも固定 IP にする。
Mask の 255.255.255.0 のとき、address 指定の最後が /24 になる。

# 中継器 WEX-733DHP (obso)

中継器は PC 側の  MAC 値を親機に送るので、いつも同じ IP が提示される。そうすると親機に対す
るリースが終ってないからなのか、接続に時間がかかったり、つながらなかったり。

```
nmcli connection edit [NAME]
```

にて

```
802-11-wireless.cloned-mac-address:     random
```

の設定をするとサクサクになった。


