# Uim

# DESTDIR 注意

```
gtk-query-immodule-2.0 --update-cache
gtk-query-immodule-3.0 --update-cache
```



# Uim-1.8.8 を Clang PGO 

```
CC=clang
CXX=clang++
CFLAGS=-O2 -fprofile-generate=/sources/gcda/uim-1.8.8
CXXFLAGS=-O2 -fprofile-generate=/sources/gcda/uim-1.8.8
LDFLAGS=-fprofile-generate=/sources/gcda/uim-1.8.8
LIBS=
```

```
./configure --prefix=/usr \
--with-qt5-immodule \
 --with-skk
```

```
main.cpp:68:55: error: invalid suffix on literal; C++11 requires a space between literal and identifie
r [-Wreserved-user-defined-literal]
#define VERSION_NAME "uim-xim under the way! Version "PACKAGE_VERSION"\n"
```

xim/main.cpp に対して
```
--- main.cpp.org        2018-12-10 00:05:51.112322110 +0900
+++ main.cpp    2018-12-10 00:04:13.402322373 +0900
@@ -65,7 +65,7 @@
 int scr_width, scr_height;
 int host_byte_order;

-#define VERSION_NAME "uim-xim under the way! Version "PACKAGE_VERSION"\n"
+#define VERSION_NAME "uim-xim under the way! Version " PACKAGE_VERSION"\n"
 const char *version_name=VERSION_NAME;
 const char *usage=
 "--help , --version :Show usage or version\n"
```

で一回目のビルド成功。``make check`` でプロファイルを集める。

```
CC=clang
CXX=clang++
CFLAGS=-O2 -fprofile-use=/sources/gcda/uim-1.8.8 -march=native
CXXFLAGS=-O2 -fprofile-use=/sources/gcda/uim-1.8.8 -march=native
LDFLAGS=-fprofile-use=/sources/gcda/uim-1.8.8
LIBS=
```

で二回目


# 旧情報


## patch が必要

Qt5.9 にしてから patch フォルダの 2 つのパッチが必要。

## FDO は？

だましだまし Makefile.qmake を書き換えながらビルドには成功したけど、

``
GTK_PATH=/opt/uim-PreFDO/lib/gtk-3.0 gtk-query-immodules-3.0 --update-cache
Cannot load module /opt/uim-PreFDO/lib/gtk-3.0/3.0.0/immodules/im-uim.so:
/opt/uim-PreFDO/lib/gtk-3.0/3.0.0/immodules/im-uim.so: undefined symbol:
__gcov_indirect_call_callee
/opt/uim-PreFDO/lib/gtk-3.0/3.0.0/immodules/im-uim.so does not export GTK+ IM module API:
/opt/uim-PreFDO/lib/gtk-3.0/3.0.0/immodules/im-uim.so: undefined symbol:
__gcov_indirect_call_callee
``

``
libtool: relink: /opt/gcc-7/bin/gcc -shared  -fPIC -DPIC  .libs/im_uim_la-gtk-im-uim.o
.libs/im_uim_la-key-util-gtk.o .libs/im_uim_la-uim-cand-win-gtk.o
.libs/im_uim_la-uim-cand-win-vertical-gtk.o .libs/im_uim_la-uim-cand-win-tbl-gtk.o
.libs/im_uim_la-uim-cand-win-horizontal-gtk.o .libs/im_uim_la-caret-state-indicator.o
.libs/im_uim_la-compose.o .libs/im_uim_la-text-util.o  -Wl,--whole-archive
../../uim/.libs/libuim-counted-init.a ../../uim/.libs/libuim-x-util.a
-Wl,--no-whole-archive  -Wl,-rpath -Wl,/usr/lib/../lib64 -Wl,-rpath
-Wl,/opt/uim-PreFDO/lib -L/sources/uim/uim/.libs -L/sources/uim/sigscheme/libgcroots/.libs
-L/usr/lib -lgtk-3 -lgdk-3 -lpangocairo-1.0 -L/usr/lib/../lib64 -lpangoft2-1.0 -lpango-1.0
-lgthread-2.0 -latk-1.0 -lcairo-gobject -lcairo -lpixman-1 -lfontconfig -lexpat -lharfbuzz
-lfreetype -lbz2 -lgraphite2 -lxcb-shm -lxcb-render -lXrender -lXext -lrt -lgdk_pixbuf-2.0
-lpng16 -lm -lgio-2.0 -lgmodule-2.0 -lz -lresolv -lgobject-2.0 -lffi -lglib-2.0 -lpcre
-lpthread -L/opt/uim-PreFDO/lib -luim -luim-scm -lgcroots -lX11 -lxcb -lXau -lXdmcp -ldl
-lgcov  -pthread -march=native -O2 -fprofile-generate -fprofile-arcs
-fprofile-dir=/sources/fdo/uim   -pthread -Wl,-soname -Wl,im-uim.so -o .libs/im-uim.so
``

というわけで lgcov が抜けたわけではない。俺には分からない。

<!-- vim: set tw=90 filetype=markdown : -->
