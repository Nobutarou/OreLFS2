# RUSTFLAGS

```
-C target-cpu=native
```

が -march=native みたいなもんらしい

```
-C opt-level=2
```

が O2 相当っぽい 

# gcc のパスの ar を探し始める

AR とかが効かない。たぶん決め打ちされてしまってる。/opt/gcc-7/bin/ar が無いといってエラー
。あたりまえだ。しかたないから ar を /opt/gcc-7/bin にリンクを貼った。

次の gcc ビルドは --prefix ではなくて、--sufix-某で適当な番号つけて /usr に入れてみるか。

# rustc-1.25 がビルドできない

上記のように gcc に sufix 付けて、CC=gcc-7.3.0 とかってしてみたけど、エラーが出る。ちゃん
と見てないけど AR とかのも gcc-ar-7.3.0 とかになんなくちゃいけないだろうけど、AR が効かな
いんだから、あきらめて rust オフィシャルの入れ方で良いのかな。どうせ firefox にしか使わな
いのだし。

<!-- vim: set tw=90 filetype=markdown : -->
