# 76.0.1

なぜか google photos のアップロードに失敗するようになった。hosts ブロックやめても firefox
の保護機能止めても失敗する。

もしかしてプロセス数が多すぎるのかと思い、以下を試すところ。

about:support#remote-processes でウェブコンテントの最大数が 8 になってた。そんな優秀な PC
じゃないのでコア数の 4 にするには about:config,  dom.ipc.processCount  

結果はそのうち更新

# リスタート

Shift-F2 でデベロッパーツールバーを出して restart 

# リスタートその 2

about:profiles で再起動ボタン

# pulseaudio

58 以降、pulseaudio を自動起動しなくなったらしいので、.xinitrc に 
``
pulseaudio --start -D
``

ちゃんと Book に書いてあったけど、-D がないと、自分の環境ではすぐに落ちちゃうみたい.

# DNS レスポンス悪い

まず、なぜか システムプロクシを使う、という設定になってた。この状態だとなぜか一旦訪問した
ドメインに drill すると、dnsmasq が初回のキャッシュを行いに行く。なんでか分からない。これ
を切ると、drill で 0ms となり大丈夫。

ただし、まだもっさりする。about:config で dns を探すといろいろあるけど、最終的には
``
network.dns.disableIPv6;true
``
が決め手のようだ

# Profile Directory

profile.ini の IsRelative=0


<!-- vim: set tw=90 filetype=markdown : -->
