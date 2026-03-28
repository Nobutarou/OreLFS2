# Jpeg の日付を変更する

## カメラの日付を間違えてたとき

jhead をつかう。

```sh
jhead hoge.jpg
```

で情報取得。Data/Time が写真撮影日だけどツールによっては File date を使うものもある （
geeqiw とか)

```sh
jhead -ta+HH:mm hoge.jpg
```

で時間単位で時刻を増やす。HH は二桁以上でも良さそう

```sh
jhead -daYYYY:MM:DD-yyyy:mm:dd hoge.jpg
```

で YYYY:MM:DD から yyyy:mm:dd 分だけずらす。これらは Data/Time に反映

```sh
jhead -ft hoge.jpg
```

で File date を Data/TIme に変更する。

<!-- vim: set tw=90 filetype=markdown : -->

