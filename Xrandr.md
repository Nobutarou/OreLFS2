# Xrandr 

ディスプレイの出力設定を切り替えるツール。HDMI に繋いでも切り替わらないときに自力でなんと
かできる。

```
# 接続しているディスプレイの一覧、解像度を表示
xrandr

# 例えば HDMI-A-0 という出力先があった場合、そこに出す
xrandr --output HDMI-A-0 --auto

# 消す
xrandr --output HDMI-A-0 --off

# 複製
# この場合 eDP が元々の Laptop の画面
xrandr --output HDMI-A-0 --same-as eDP

# 左に置く
xrandr --output HDMI-A-0 --left-of eDP --auto

# primary にする
xrandr --output HDMI-A-0 --primary
```

<!-- vim: set tw=90 filetype=markdown : -->

