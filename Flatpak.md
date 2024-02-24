# 文字化けを直す

```
flatpak run --command=fc-cache (アプリ名) -f -v
```

kicad の場合

```
flatpak run --command=fc-cache org.kicad.KiCad -f -v
```

# PulseAudio に接続できない

今まで ```pulseaudio --start -D``` で起動してきたが、```start-pulseaudio-x11``` で起動する
必要がある。しかし何故かすぐに終了してしまうので、flatpak のときのみ使うのが良さそうだ

また flatpak 起動時に

```
PULSE_SERVER=unix:/tmp/pulse-XE7cIQuj2CTJ/native flatpak run  org.pulseaudio.pavucontro
```

というように環境変数が必要

# file chooser does not open

xdg-desktop-portal might needed. (Hey Flatpak, you shall install by yourself...)

# file セレクターが Qt App で出ない

Qt app には xdg-desktop-portal-kde が必要。ほぼ plasma までの build が必須。

以下は古い情報

```
flatpak run --command=sh org.kde.kdenlive
```

とでもすると Flatpak 環境で sh が開く。

```
rm -v /run/user/1001/flatpak-info
kdenlive
```

などとするとファイルセレクターが出るようになる。

<!-- vim: set tw=90 filetype=markdown : -->
