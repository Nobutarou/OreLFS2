# PGP 鍵の検証エラー

```
==> gpg でソースファイルの署名を検証...
    dropbox-lnx.x86_64-67.4.83.tar.gz ... 失敗 (不明な公開鍵 FC918B335044912E)
    ==> エラー: PGP 鍵を検証できませんでした！
    ==> エラー: Makepkg was unable to build dropbox.
```

みたいな場合、

```
gpg --keyserver keys.gnupg.net --recv-key FC918B335044912E
```

と言うような感じで解決できる。
