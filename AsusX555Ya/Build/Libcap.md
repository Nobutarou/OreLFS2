# Clang

CC, CFLAGS, LDFLAGS を見てくれないので Make.rules を直接編集

DESTDIR だと、一時的に libcap.so がなくなってこまるので、/lib などに古いのを置いておいて /usr/lib に graft してから、/lib の古いのを消すのが良さそう。


<!-- vim: set tw=90 filetype=markdown : -->
