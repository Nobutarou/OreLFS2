#  Radeon ようわからん

LFS7.6, Linux-3.16.2 で ACPI を有効にしていると、fn+f5, f6 のバックライト調整を使うと X が
ハングする。コンソールでは問題なし。それから vgaswitcheroo が何しても、もう一大の GPU が
DynOff のままで、うんともすんとも言わない。 xrandr --listproviders も一つしか現れない。

acpi=off で無効にすると、vgaswitcheroo が無くなる。バックライトは大丈夫。xrandr
--listproviders は、なぜか 3 つ出てくるが、2 つは同じもの。何もしてなくても温度が 65 〜
 70 度になる。http://is.gd/BOsRqT あたりでパワー落せるか, profile を low とかにしても、パ
 フォーマンスは知らないけど、熱い。ちょっとだめだ。

あとは、嘘みたいな xcomposer を使えば、DynOff から目覚めるみたいな話しがあるので、試してみ
るか。http://is.gd/Ui7cUX  --> やっぱり駄目だった。

では acpi ありの状態でバックライトの問題をなんとかしていこう. Linux-3.10.10 をまねて
```linux
# 3.10.01 のころにはなかった模様
	CONFIG_ACPI_VIDEO = n

	CONFIG_BACKLIGHT_LCD_SUPPORT = y
# CONFIG_LCD_CLASS_DEVICE is not set

```

で様子を見よう。 --> Fn+F5, F6 でバックライトの明るさを調整できなくなった --> 

```zsh
	echo 64 > /sys/class/backlight/radeon_bl0/brightness
```

で調整できた。backlightup と backlightdown を書いてショートカットキーに登録しておいた

ハングの問題は fglrx でも出ていた。これで出なくなるなら、GPU を使える fglrx に切りかえたい
な。 --> boot オプションで radeon=no とかしても無効にならないから、ビルドしなおすか。

で、fglrx にすると、/sys/class/backlight/asus-nb-wmi/ に変更になった。でこの状態だと
Fn+F5/F6 が有効で、ハングもしない。

Fn まわりおかしい。Fn+F2 の wan on/off もハングする。

でしばらく使っていたんだけど、ctrl-alt-fn とか ctrl-alt-break で tty に戻らない。ググると
uvesafb 使えって言う人がいる。面倒だなあ.

--> いろいろ試したけど、あきらめた。uvesafb は必要な .h が無い。数年前から更新されてないみ
たいだし。kernel の fb ドライバーをいくつか試したけど、xorg 起動後 black screen になる。
tty は無かったものとして考えるべきなんだろう
