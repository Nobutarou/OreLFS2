# Seamonkey-2.49.4

## 二回目

```
grep -rIl '\-O3' ./ > O3files.txt 
foreach i in $(cat O3files.txt ) 
do
cp $i $i.bakbak
sed -i "s/-O3/-O1/" $i
diff -u $i $i.bakbak >> diffdiff.log
done
```

のように -O3 を排除し、次の mozconfig,

```
ac_add_options MOZ_PGO=1
mk_add_options MOZ_MAKE_FLAGS="-j3"
ac_add_options --disable-necko-wifi
ac_add_options --enable-system-hunspell
ac_add_options --disable-gconf
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu
ac_add_options --prefix=/home/snob/.local/seamonkey-2.49.4
ac_add_options --enable-application=suite
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests
ac_add_options --enable-optimize="-O1"
ac_add_options --enable-strip
ac_add_options --enable-install-strip
ac_add_options --disable-gio
ac_add_options --enable-official-branding
ac_add_options --enable-safe-browsing
ac_add_options --enable-url-classifier
ac_add_options --enable-system-cairo
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman
ac_add_options --with-pthreads
ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib
```

成功はしたようだが PGO した気配はない。-fprofile-generate した様子がないから、そもそも無効
なのだろう. 

## 一回目は失敗

mozconfig が以下で、

``` 
ac_add_options MOZ_PGO=1
# If you have a multicore machine, all cores will be used by default.
# If desired, you can reduce the number of cores used, e.g. to 1, by
# uncommenting the next line and setting a valid number of CPU cores.
mk_add_options MOZ_MAKE_FLAGS="-j3"

# If you have installed DBus-Glib comment out this line:
# ac_add_options --disable-dbus

# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
ac_add_options --disable-necko-wifi

# Uncomment these lines if you have installed optional dependencies:
ac_add_options --enable-system-hunspell
#ac_add_options --enable-startup-notification

# Uncomment the following option if you have not installed PulseAudio
#ac_add_options --disable-pulseaudio
# and uncomment this if you installed alsa-lib instead of PulseAudio
#ac_add_options --enable-alsa

# Comment out following option if you have gconf installed
ac_add_options --disable-gconf

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu



# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/home/snob/.local/seamonkey-2.49.4
ac_add_options --enable-application=suite

ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests

ac_add_options --enable-optimize="-O1 -flto -fno-delete-null-pointer-checks -fno-lifetime-dse -fno-schedule-insns2"
ac_add_options --enable-strip
ac_add_options --enable-install-strip

# ac_add_options --enable-gio
ac_add_options --disable-gio
ac_add_options --enable-official-branding
ac_add_options --enable-safe-browsing
ac_add_options --enable-url-classifier

# From firefox-40 (and the corresponding version of seamonkey),
# using system cairo caused seamonkey to crash
# frequently when it was doing background rendering in a tab.
# This appears to again work in seamonkey-2.49.2
ac_add_options --enable-system-cairo
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

ac_add_options --with-pthreads

ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib
```

```
/sources/seamonkey-2.49.4/mailnews/mime/src/mimemsig.cpp:21:1: 備考: ‘:mimeMultipartSignedClass’t wapreviously declared here
 MimeDefClass(MimeMultipartSigned, MimeMultipartSignedClass,
 ^
/sources/seamonkey-2.49.4/mailnews/mime/src/mimemsig.cpp:21:1: 備考: code may be misoptimized unless -fno-strict-aliasing is used
/sources/seamonkey-2.49.4/mailnews/mime/src/mimebuf.h:21:16: 警告: ‘:mime_LineBuffer’  の型は元の宣aと一致しません [-Wlto-type-mismatch]
 extern "C" int mime_LineBuffer (const char *net_buffer, int32_t net_buffer_size,
                ^
/sources/seamonkey-2.49.4/mailnews/mime/src/mimebuf.cpp:156:1: 備考: ‘3mime_LineBuffer’  was previouy declared here
 mime_LineBuffer (const char *net_buffer, int32_t net_buffer_size,
 ^
/sources/seamonkey-2.49.4/mailnews/mime/src/mimebuf.cpp:156:1: 備考: code may be misoptimized unless -fno-strict-aliasing is used
test "$(nm -g libxul.so | grep _NSModule$ | grep -vw refptr | sort | sed -n 's/^.* _*\([^ ]*\)$/\1/;1p;$p' | xargs echo)" != "start_kPStaticModules_NSModule end_kPStaticModules_NSModule" && echo "NSModules are not ordered appropriately" && exit 1 || exit 0 ; test "$(readelf -l libxul.so | awk 'libxul.so == "LOAD" { t += 1 } END { print t }')" -le 1 && echo "Only one PT_LOAD segment" && exit 1 || exit 0
NSModules are not ordered appropriately
make[4]: *** [/sources/seamonkey-2.49.4/mozilla/config/rules.mk:803: libxul.so] エラー 1
make[4]: *** ファイル 'libxul.so'　を削除します
make[4]: ディレクトリ '/sources/seamonkey-2.49.4/obj-x86_64-pc-linux-gnu/toolkit/library' から出ます
make[3]: *** [/sources/seamonkey-2.49.4/mozilla/config/recurse.mk:71: toolkit/library/target] エラー 2
make[3]: ディレクトリ '/sources/seamonkey-2.49.4/obj-x86_64-pc-linux-gnu' から出ます
make[2]: *** [/sources/seamonkey-2.49.4/mozilla/config/recurse.mk:33: compile] エラー 2
make[2]: ディレクトリ '/sources/seamonkey-2.49.4/obj-x86_64-pc-linux-gnu' から出ます
make[1]: *** [/sources/seamonkey-2.49.4/mozilla/config/rules.mk:523: default] エラー 2
make[1]: ディレクトリ '/sources/seamonkey-2.49.4/obj-x86_64-pc-linux-gnu' から出ます
make: *** [client.mk:397: build] エラー 2
```

と落ちる。LTO 関連で何かあるみたいだから LTO はあきらめたほうが良さそう。

あと、-O3 が出てた。``grep -rlI "\-O3" ./``  掛けるとたくさん出てくる。

<!-- vim: set tw=90 filetype=markdown : -->
