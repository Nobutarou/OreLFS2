# gdk-pixbuf-2.38.0

meson で /usr/lib64 なのを /usr/lib に変えるすべを知らないので、 /usr/lib64/gdk-pixbuf-2.0/2.10.0/loaders に各ローダーが来るようにならないと行けないけど、以前にビルドした rsvg なんかは /usr/lib 配下なので、ローダーの置き直しが必要だった。(/usr/lib64/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader-svg.so)


<!-- vim: set tw=90 filetype=markdown : -->
