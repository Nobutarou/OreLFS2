# 最小フォントサイズの設定

```
a,div,p,span,td { font-size:max(10px, 1em) !important;} 
```

みたいにする。ワイルドカードは使えないようだ。

# 最後のタブを保持

/usr/share/glib-2.0/schemas/org.gnome.epiphany.gschema.xml の keep-window-open を true に
して 

```
glib-compile-schemas /usr/share/glib-2.0/schemas
```

# 動画

BLFS には gst-plugins-{base,bad} となってるが good, libav も入れる必要があった
