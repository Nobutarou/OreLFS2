# SVG icons

I cannot see svg icons. Maybe I have to build after librsvg or, I need some configure
option.

# MiniIconSize

トーマスがとても簡単だと言ってるから、ソースを書きかえてみる。

## Test01

なんか MINI_ICON のサイズを決めてるっぽいところがあったので、直接 32 を指定してみた。
とりあえずでかくなった。

```
--- /sources/fvwm-2.6.7/fvwm/ewmh_icons.c.org   2018-05-07 21:15:07.600367109 +0900
+++ /sources/fvwm-2.6.7/fvwm/ewmh_icons.c       2018-05-07 21:15:47.080367003 +0900
@@ -676,10 +676,10 @@
        return;
 }

-#define MINI_ICON_WANTED_WIDTH  16
-#define MINI_ICON_WANTED_HEIGHT 16
-#define MINI_ICON_MAX_WIDTH 22
-#define MINI_ICON_MAX_HEIGHT 22
+#define MINI_ICON_WANTED_WIDTH  32
+#define MINI_ICON_WANTED_HEIGHT 32
+#define MINI_ICON_MAX_WIDTH 48
+#define MINI_ICON_MAX_HEIGHT 48
 #define ICON_WANTED_WIDTH 56
 #define ICON_WANTED_HEIGHT 56
 #define ICON_MAX_WIDTH 100
@@ -718,7 +718,7 @@
                wanted_w = MINI_ICON_WANTED_WIDTH;
                wanted_h = MINI_ICON_WANTED_HEIGHT;
                max_w = MINI_ICON_MAX_WIDTH;
-               max_h = ICON_MAX_HEIGHT;
+               max_h = MINI_ICON_MAX_HEIGHT;
                fpa.mask = 0;
        }
        else
```

## Test02

IconSize で調べると fw->min_icon_width とかやってるから、それを ewmh_icons にも使ってみる。

```
--- ewmh_icons.c.org    2018-05-07 21:15:07.600367109 +0900
+++ ewmh_icons.c        2018-05-07 22:13:36.590357670 +0900
@@ -715,10 +715,10 @@

        if (is_mini_icon)
        {
-               wanted_w = MINI_ICON_WANTED_WIDTH;
-               wanted_h = MINI_ICON_WANTED_HEIGHT;
-               max_w = MINI_ICON_MAX_WIDTH;
-               max_h = ICON_MAX_HEIGHT;
+               wanted_w = fw->min_icon_width;
+               wanted_h = fw->min_icon_height;
+               max_w = fw->max_icon_width;
+               max_h = fw->max_icon_height;
                fpa.mask = 0;
        }
        else
```

これで Style * IconSize 32 32 とかすると、FvwmIconMan の MiniIcon に適用された。

<!-- vim: set tw=90 filetype=markdown : -->

