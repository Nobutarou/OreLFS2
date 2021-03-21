# PulseAudio に接続できない

今まで ```pulseaudio --start -D``` で起動してきたが、```start-pulseaudio-x11``` で起動する
必要がある。しかし何故かすぐに終了してしまうので、flatpak のときのみ使うのが良さそうだ

また flatpak 起動時に

```
PULSE_SERVER=unix:/tmp/pulse-XE7cIQuj2CTJ/native flatpak run  org.pulseaudio.pavucontro
```

というように環境変数が必要

# file chooser does not open

xdg-desktop-portal-gtk is needed.

<!-- vim: set tw=90 filetype=markdown : -->
