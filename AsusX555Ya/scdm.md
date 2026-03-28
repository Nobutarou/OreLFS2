# scdm 使うと、systemctl reoot や poweroff に 30 秒くらい掛かる

scdm で X 起動すると、件名のようになる。cdm だとそうならない。根本的な原因は理解できていな
い。

当初は reboot かけた後、sawfish を quit すると即座にシャットダウンが続くので、それで対処し
ていたが、毎回は面倒。

最初は jounalctl で
```
 4月 09 22:28:42 usehage systemd[1]: Stopping D-Bus System Message Bus...
 4月 09 22:28:42 usehage systemd[1]: Stopped D-Bus System Message Bus.
 4月 09 22:28:42 usehage systemd[1]: Failed to propagate agent release message: Connection reset by peer
```
で、何となく dbus ぽい気がする。archwiki だと /etc/X11/xinit/30-dbus.sh を .xinitrc に読ま
せろと書いてあるけど、ググって

```zsh
dbuslaunch="`which dbus-launch 2>/dev/null`"
if [ -n "$dbuslaunch" ] && [ -x "$dbuslaunch" ] && [ -z "$DBUS_SESSION_BUS_ADDRESS" ];
then
    eval `$dbuslaunch --sh-syntax --exit-with-session`
fi
```

すると、エラーが変化。
```
 4月 09 23:00:13 usehage dbus[261]: [system] Activating via systemd: service name='org.freedesktop.login1' unit='dbus-org.freedesktop.login1.service'
 4月 09 23:00:13 usehage dbus[261]: [system] Activation via systemd failed for unit 'dbus-org.freedesktop.login1.service': Refusing activation, D-Bus is shutting down.
 4月 09 23:00:13 usehage sudo[2299]: pam_systemd(sudo:session): Failed to create session: Refusing activation, D-Bus is shutting down.
 4月 09 23:00:32 usehage org.a11y.Bus[2188]: GLib-GIO-Message: Using the 'memory' GSettings backend.  Your settings will not be saved or shared with other applications.
```

3 行目から 4 行目に 30 秒も掛かっている。/etc/pam.d/sudo の問題のような気もするけど,

```zsh
systemctl reboot -f 
# systemctl poweroff -f
```
でうまく動きそう

ま、それでも良かったんだけど、ブートプロセスをちゃんとしてくれないのも嫌なので、

```sh
systemctl reboot && pkill sawfish
```

に変更した。

<!-- vim: set tw=90 filetype=markdown : -->
