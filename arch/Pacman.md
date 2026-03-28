# pacman -Syu 失敗 1

署名は信頼されていません

```
sudo pacman -S archlinux-keyring
```

-S が正しいのかどうか知らないけどこれで keyring が更新される。

そうしたら ``pacman -Syu`` が通る。

<!-- vim: set tw=90 filetype=markdown : -->

