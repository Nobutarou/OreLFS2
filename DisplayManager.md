# Display Manager (Login Manager) 

## Qingy

別に悪くないのだけど、他も試したいというのが人情だろう。

## CDM

ソースは

https://github.com/ghost1227/cdm

情報は、

https://wiki.archlinux.org/index.php/CDM

dialog が必要

http://invisible-island.net/dialog/dialog.html

~/.cdmrc には
```bash
binlist=(
  '~/.xsession'                    # Launch your X session,
  '/bin/zsh'	               # or just execute your shell,
	)
namelist=(X Tty)
flaglist=(X C)
```
みたいに書く。

で .zprofile に

```zsh
if [[ "$(tty)" == '/dev/tty1' ]]; then
	/usr/bin/cdm ~/.cdmrc
fi
```

/etc/X11/Xwrapper.config

```
needs_root_rights=auto
allowed_users=anybody
# 通常は、コンソールにログインしているユーザーしか startx 出きない。
```

としておいて、普通に tty1 にログインする。

sawfish 起動後の xfce4-panel は、良くわからないけど dbus-run-session 付きじゃないと動かな
い。


<!-- vim: set tw=90 filetype=markdown : -->

