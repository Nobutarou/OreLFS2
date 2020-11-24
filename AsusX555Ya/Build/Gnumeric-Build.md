# Goffice に注意

``
go_conf_get_node: assertion 'parent || key' failed
``

こういう感じのメッセージが大量に出て、なかなかファイルを開けない。Goffice の問題らしく、さ
らには gsetting-desktop-schemas の問題らしい。そっちに問題があるのか Gnumeric 側が間違って
るのかは知らないが。

``
./configure --prefix=/usr --disable-introspection  --with-config-backend=keyfile
``
でやると、うまく行った

# Goffice に注意、その 2

gsetting-desktop-scheas はどうも DESTDIR のせいらしい。本体のインストール時だけではなくて
、これを使うソフトウェアを入れたなら↓をやらないといけないらしい。

``
glib-compile-schemas /usr/share/glib-2.0/schemas
``
 
いや勝手にフォルダ見てくれても良くね？

やっぱテキスト設定ファイルが一番だな。

<!-- vim: set tw=90 filetype=markdown : -->
