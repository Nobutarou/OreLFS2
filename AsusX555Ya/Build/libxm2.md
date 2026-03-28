# DESTDIR の注意

Python モジュールを /opt/liblmx2-2.9.7/opt/Python-3.6.4/usr/lib/python3.6/site-packages のように
インストールしてしまう。

Python module path は既に修正してあるので /opt/liblmx2-2.9.7/usr/lib/python3.6/site-packages  に移動させてから graft すること

<!-- vim: set tw=90 filetype=markdown : -->
