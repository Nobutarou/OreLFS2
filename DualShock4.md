# DualShock4 を使いたい

## 番外編、windows10

steam のビッグスクリーンモードだと、キーとマウスの扱いいなる。で初期設定がゴミなのでカスタ
マイズが大変。それから、ds4windows は使えない。

steam の普通モードだと、ゲームパッド扱いなんだけど、どうもボタンの認識が変なのか、同じボタ
ンとして認識されてしまったり、複数のボタンを素早く押したような挙動になる。ds4windows はや
っぱり変.

というわけで一番の解決策は GOG から購入して ds4windowsを通すこと。xbox 扱いになるので ×が A で○が B とか、ちょっと日本人的には変な気がするけど、そういうもんだと思えばそんなに迷わない。

## ds4drv をユーザー権限で使う

まず /dev/uinput のパーミッションを貰う必要があり、 /etc/udev/rules.d/50-ds4drv.rules に

```
KERNEL=="uinput", MODE="0666"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:05C4.*", MODE="0666"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:09CC.*", MODE="0666"
```

なのだが、罠がある。実は kernel が起動したときに /dev/uinput が作成されるが uinput モジュ
ールはロードされていないので、上記のルールはキックされない。そこで
/etc/modules-load.d/uinput.conf に

```
uinput
```

として起動時にモジュールをロードさせる。

ま、こういうことをしたくないなら素直に su chmod 0666 /dev/uinput すれば良い。

## とりあえず USB 接続

カーネルは Gentoo wiki, https://is.gd/D3M5PP を参考にしながら Sony ドライバーはモジュールにしてみた。

あとは Arch Wiki, https://is.gd/TRBZRd を参考にして、cat /dev/input/js0 や cat
/dev/input/event13 などで、文字化けが起こることを確認。event13 ではタッチパッドも認識して
る感じだけどどうかな。それから、sony_hid モジュールがロードされないのはなんでだろう。そん
な感じ。あ、event はグループ input に所属してる必要があるみたいなのでそうしてる。

でテラリアからゲームパッドとして認識されてないみたいで、全てのボタンが反応しない。

ds4drv --hidraw しても全然認識してくれない。

どういうことかと思いながら jstest-gtk でテストするとちゃんとリストに出てくるし、タッチパッ
ド以外全て動作している。sdl-jstest でも タッチパッド以外は全部動作している。

linuxconsole に含まれる fftest だと

```
% fftest /dev/input/event13                                      /sources/linuxconsole/utils master
Force feedback test program.
HOLD FIRMLY YOUR WHEEL OR JOYSTICK TO PREVENT DAMAGES

Device /dev/input/event13 opened
Features:
  * Absolute axes: X, Y, Z, RX, RY, RZ, Hat 0 X, Hat 0 Y,
    [3F 00 03 00 00 00 00 00 ]
  * Relative axes:
    [00 00 ]
  * Force feedback effects types:
    Force feedback periodic effects:
    [00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ]
  * Number of simultaneous effects: 0

Uploading effect #0 (Periodic sinusoidal) ... Error:: Function not implemented
Uploading effect #1 (Constant) ... Error: Function not implemented
Uploading effect #2 (Spring) ... Error: Function not implemented
Uploading effect #3 (Damper) ... Error: Function not implemented
Uploading effect #4 (Strong rumble, with heavy motor) ... Error: Function not implemented
Uploading effect #5 (Weak rumble, with light motor) ... Error: Function not implemented
Enter effect number, -1 to exit
```

とまあ、いろいろエラーが出てる。

で xboxdrv で xbox に偽装するのは？？？

```zsh
% xboxdrv --evdev /dev/input/event13 \
--evdev-keymap BTN_EAST=a
```

とかってやると、×で a を押したことになる。BTN_EAST などは evtest で探す。どうも Arch Wiki
とボタン名が違うようだ。型式が新しいのかな。。。まそれは良いんだけどタッチパッドは相変らず
使えない模様. 

でまあ何にせよ Terraria で認識されない。

で SDL_GAMECONTROLLERCONFIG を使う方法だと認識された。だけどこれ、L2 や 右スティック押しを
認識させるのがほぼ不可能。敏感すぎて。そしてどにみちトラックパッドは使えない。いや、トラッ
クパッドは無理でもボタン割り当ては無理じゃない。jstest-gtk に一致させれば良い。

```zsh
export SDL_GAMECONTROLLERCONFIG="030000004c050000cc09000011010000,Sony Interactive Entertainment Wireless Controller,platform:Linux,x:b0,a:b1,b:b2,y:b3,back:b8,guide:b13,start:b9,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,dpup:h0.1,leftshoulder:b4,lefttrigger:b6,rightshoulder:b5,righttrigger:b7,leftstick:b10,rightstick:b11,leftx:a0,lefty:a1,rightx:a2,righty:a5,"
```

で、なんとなく ds4drv に issue を上げてググってたら, DS4 Slim で同じ症状が出るとかいう
closed な issue #104 があって、それだった。今のマスターのは治っているんだけど、pip で入れ
たから古かったみたい。~/.local/lib/python3.5/site-packages/ds4drv/backends/hidraw.py を

```
HID_DEVICES = {
    "Sony Computer Entertainment Wireless Controller": HidrawUSBDS4Device,
    "Wireless Controller": HidrawBluetoothDS4Device,
                "Sony Interactive Entertainment Wireless Controller": HidrawUSBDS4Device,
}
```

のように一番下の一行を dmesg に合わせて追加したら認識した。

でもって、テラリアするときに SDL_GAMECONTROLLERCONFIG が不要で PS コントローラとして認識し
てくれた。トラックパッドも使える。

```sh
ds4drv --hidraw --trackpad-mouse
```

やりましたー！！！
<!-- vim: set tw=90 filetype=markdown : -->
