# Xorg

## DRI3 を有効にする

https://wiki.archlinuxjp.org/index.php/ATI

によると /etc/X11/xorg.conf.d/ に

```xorg.conf
Section "Device"
    Identifier "Radeon"
    Driver "radeon"
		Option "DRI" "3"
EndSection
```

とでも書けば良さそうだったんだけど、どうも読んでくれない。なので

```sh
# :0 はすでに実行中なので
Xorg -configure :1
```

で /root/xorg.conf.new が作られるので、/etc/X11/xorg.conf にコピーして、以下のようにしたら
有効になった。

```xorg.conf
Section "ServerLayout"
	Identifier     "X.org Configured"
	Screen      0  "Screen0" 0 0
	InputDevice    "Mouse0" "CorePointer"
	InputDevice    "Keyboard0" "CoreKeyboard"
EndSection

Section "Files"
	ModulePath   "/usr/lib/xorg/modules"
	FontPath     "/usr/share/fonts/X11/misc/"
	FontPath     "/usr/share/fonts/X11/TTF/"
	FontPath     "/usr/share/fonts/X11/OTF/"
	FontPath     "/usr/share/fonts/X11/Type1/"
	FontPath     "/usr/share/fonts/X11/100dpi/"
	FontPath     "/usr/share/fonts/X11/75dpi/"
EndSection

Section "Module"
	Load  "glx"
EndSection

Section "InputDevice"
	Identifier  "Keyboard0"
	Driver      "kbd"
EndSection

Section "InputDevice"
	Identifier  "Mouse0"
	Driver      "mouse"
	Option	    "Protocol" "auto"
	Option	    "Device" "/dev/input/mice"
	Option	    "ZAxisMapping" "4 5 6 7"
EndSection

Section "Monitor"
	Identifier   "Monitor0"
	VendorName   "Monitor Vendor"
	ModelName    "Monitor Model"
EndSection

Section "Device"
        ### Available Driver options are:-
        ### Values: <i>: integer, <f>: float, <bool>: "True"/"False",
        ### <string>: "String", <freq>: "<f> Hz/kHz/MHz",
        ### <percent>: "<f>%"
        ### [arg]: arg optional
        #Option     "Accel"              	# [<bool>]
        #Option     "SWcursor"           	# [<bool>]
        #Option     "EnablePageFlip"     	# [<bool>]
        #Option     "ColorTiling"        	# [<bool>]
        #Option     "ColorTiling2D"      	# [<bool>]
        #Option     "RenderAccel"        	# [<bool>]
        #Option     "SubPixelOrder"      	# [<str>]
        #Option     "AccelMethod"        	# <str>
        #Option     "ShadowPrimary"      	# [<bool>]
        #Option     "EXAVSync"           	# [<bool>]
        #Option     "EXAPixmaps"         	# [<bool>]
        #Option     "ZaphodHeads"        	# <str>
        #Option     "SwapbuffersWait"    	# [<bool>]
        #Option     "DeleteUnusedDP12Displays" 	# [<bool>]
        #Option     "DRI3"               	# [<bool>]
        Option     "DRI"  "3"            	# <i>
        #Option     "TearFree"           	# [<bool>]
	Identifier  "Card0"
	Driver      "radeon"
	BusID       "PCI:0:1:0"
EndSection

Section "Screen"
	Identifier "Screen0"
	Device     "Card0"
	Monitor    "Monitor0"
	SubSection "Display"
		Viewport   0 0
		Depth     1
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     4
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     8
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     15
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     16
	EndSubSection
	SubSection "Display"
		Viewport   0 0
		Depth     24
	EndSubSection
EndSection
```

/var/log/Xorg.0.log には

```log
(**) RADEON(0): Option "DRI" "3"

省略

(**) RADEON(0): DRI3 enabled
```

となった。何が悪かったのかは分からない。

## 画面をオフにしない

```sh
xset s noblank
```

を昔から使っていたのだけど、画面が消えていることに気づる。noblank はスクリーンセーバーが動
くときに背景をブランクにするかどうかと言うもの。最近は DPMS と言う別の機構でモニターの電源
がオフにされたりしてるらしい。

```
$ xset q
DPMS (Energy Star):
  Standby: 600    Suspend: 600    Off: 600
  DPMS is Enabled
  Monitor is On
```

と 10 分で電源を切るらしい。

https://wiki.archlinuxjp.org/index.php/Display_Power_Management_Signaling

が詳しいけど、せっかくの機能をオフにするのももったいないから、

```
xset s -dpms
```

で、状況に応じて使うか

<!-- vim: set tw=90 filetype=markdown : -->

