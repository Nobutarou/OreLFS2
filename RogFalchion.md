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

## hwdb ファイルの書き方

いざというとき自分で書けるようにしておきたい。
	
https://yulistic.gitlab.io/2017/12/linux-keymapping-with-udev-hwdb/

が詳しい

```
sudo evtest
```

で ASUSTeK ROG FALCHION System Control を監視して、自分ではやってないけどシャットダウンの
ときに押されるキーボードを見つけることになる。

ちなみにスリープから解除したときの反応はこうだった。
```
Select the device event number [0-26]: 15
Input driver version is 1.0.1
Input device ID: bus 0x3 vendor 0xb05 product 0x193e version 0x111
Input device name: "ASUSTeK ROG FALCHION System Control"
Supported events:
  Event type 0 (EV_SYN)
  Event type 1 (EV_KEY)
    Event code 143 (KEY_WAKEUP)
  Event type 4 (EV_MSC)
    Event code 4 (MSC_SCAN)
Properties:
Testing ... (interrupt to exit)
Event: time 1642082274.195156, type 4 (EV_MSC), code 4 (MSC_SCAN), value 10083
Event: time 1642082274.195156, type 1 (EV_KEY), code 143 (KEY_WAKEUP), value 1
Event: time 1642082274.195156, -------------- SYN_REPORT ------------
```

``evdev:input:b*v0B05p193Ee0111*`` は b<bus_id>v<vendor_id>p<product_id>e<version_id>-<modalias> でワイルドカード OK のようだ。環境で変化する可能性のある bus_id と意味が分かってない modalias がワイルドカードとなっているようだ。 

どうも一般的に 10081 が電源キーで 10082 がスリープのようだ。で reserved でブロックできるらしい。いっそのこと全部の 10081, 10082 を reserved にしても自分の実用上問題なさそうだ。

# /dev/input を rm する方法はだめだった

ASUSTek ROG FALCHION 以外の /dev/input/event を全部削除したが、それでもシャットダウンした。

``sudo evtest`` で event id は分かる。

/dev/input はユーザーのために作られただけで、システム上そのデバイスがなくなったわけではな
いということなのだろう。

# 未検証の可能性

/etc/systemd/logind.conf で HandlePowerKey=ignore にしたら?

<!-- vim: set tw=90 filetype=markdown : -->

