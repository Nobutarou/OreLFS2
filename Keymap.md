# キーマップの変更方法

## setxkbmap を使う方法

こちらの ``! option `` の部分を見ながら、使う。

https://gist.github.com/jatcwang/ae3b7019f219b8cdc6798329108c9aee

丁度良いのを見つけたら使う感じ。

```
# 日本語配列
setxkbmap jp

# caps を windows キーに
setxkbmap -option caps:super

# ctrl-alt-break を無効に
setxkbmap -option terminate:ctrl_alt_bksp
```
## xmodmap を使う方法

~/.Xmodmap に書き込んで行く。

.xinitrc に ``xmodmap ~/.Xmodmap`` があるので X 起動時に有効になる。

.xinitrc に無いなら、自分で書こう。

これは無変換を ESC にする例。

```
keycode 102 = Escape
```

Escape みたいなのは ``/usr/include/X11/keysymdef.h`` を見る。
