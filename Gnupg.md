# 毎回パスワードを聞かれたい

gpg-agent が標準だと勝手にパスワードを保存してしまう。それだと PC 盗まれたら終りじゃない。

~/.gnupg/gpg-agent.conf
``
max-cache-ttl 1
default-cache-ttl 1
no-allow-external-cache
``

上から最大一分保存、標準で一分保存、一切保存しない。無駄が多い気がするけどこれで毎回聞いて
くれるから良しとする

# Yubikey などの token 使いたいなら

libusb-compat, pcsclite を先に入れてから build する

<!-- vim: set tw=90 filetype=markdown : -->
