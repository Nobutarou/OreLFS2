# 0.33

Lua5.2 の BLFS のメンテが酷いようで、そのままだとインストールできないし $CC -llua で not
found となる。Lua5.2 自体がもうメンテされてないので、フロントエンドを探すか、vlc や
mplayer に乗り換えるほうが良いかもしれない。

# 0.32

ビルドの時に ffmpeg への依存がなくなってるのかな？

# DESTDIR は

``
./waf install --destdir="$pkgdir"
``

分からないときは Arch の PKGBUILD だね
<!-- vim: set tw=90 filetype=markdown : -->
