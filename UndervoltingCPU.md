# CPU の電圧を下げる 

ググると PHC なんてのが出てくるので入れてみたけど、うちの A6-3400M には未対応みたい。と言
うか、2008 年くらいが最終リリースとなっている。

https://wiki.archlinux.org/index.php/PHC

http://www.linux-phc.org/forum/viewtopic.php?f=13&t=2

ということで他を当たる。

## TurionPowerControl

https://github.com/mh0rst/turionpowercontrol

これも相当放置されているんだけど、一応動いた。

電圧値はここの値を参考にした。 

http://k53ta.wiki.fc2.com/wiki/K10stat 

で systemd で動かすべく、undervolting.service を書いた。

```sh
[Unit]
Description=Undervoling APU
After=local-fs.target

[Service]
Type=simple
PIDFile=/run/undervolting.pid
ExecStart=\
/usr/bin/tpc -set core all ps 1 freq 1400 vc 0.9875 ps 2 freq 1300 vc 0.9750 ps 3 freq 1200 vc 0.9625 \
        ps 4 freq 1100 vc 0.95 ps 5 freq 1000 vc 0.9375 ps 6 freq 900 vc 0.9250 \
        ps 7 freq 800 vc 0.9

[Install]
WantedBy=multi-user.target 
```

```sh
# 実行
systemctl start undervolting

# 起動時に自動実行
systemctl enable undervolting
```
