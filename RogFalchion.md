# Rog Falchion がスリープに合わせて Linux をシャットダウンしてしまう

https://askubuntu.com/questions/1351203/how-do-i-stop-my-rog-falchion-wireless-keyboard-from-rebooting-ubuntu

```
xinput disable "ASUSTeK ROG FALCHION System Control"
xinput disable "ASUSTeK ROG FALCHION Consumer Control"
xinput disable "ASUSTeK ROG GLADIUS III WIRELESS System Control"
xinput disable "ASUSTeK ROG GLADIUS III WIRELESS Consumer Control"
```

はだめだった。多分 Ubuntu の人と違い、TTY から startx してるのが影響してると思う。
System に直でシャットダウンキー送りつけてるのだと思う。
こういうのどうやって確認するんだろう。

で効果があったのは一番最後の

https://gist.github.com/jnettlet/afb20a048b8720f3b4eb8506d8b05643

/etc/udev/hwdb.d/99-RogFalchion.hwdb

```
evdev:input:b*v0B05p193Ee0111*
  KEYBOARD_KEY_10081=reserved
  KEYBOARD_KEY_10082=reserved
```

```
systemd-hwdb update
```

直後は駄目だったけど、再起動したあとはうまく行っている。

<!-- vim: set tw=90 filetype=markdown : -->

