# Vlc で DVD を再生するまでの道のり

```
open of `dvd:///dev/sr0' failed vlc
```

だね。たぶん libdvd まわりを一つも入れてないのが影響してると思う。

## ファイル再生できるように

でまずは mount してファイルを再生してみようと思ったら udf が無効でマウントできなかったので
、UDF を有効にしてやりなおし。でファイルからの再生は成功。

## うるさいのをなんとかする

Arch wiki の https://is.gd/FKIZIz   

```zsh
eject -X /dev/sr0  # 最高回転倍率表示。うちのは 24
eject -x 12 /dev/sr0 # 回転半減させてみる。
```

## libdvd あたりを入れる。

libdvdcss, libdvdread, libdvdnav のうち、おそらく libdvdread だろうけど、入れといて困るラ
イブラリじゃないので 3 つとも入れてみる。再ビルドしないと

```
core input error: open of `dvd:///dev/sr0' failed
VLC is unable to open the MRL 'dvd:///dev/sr0'. Check the log for details.
```

出力に libdvd 云々が出てこないから、もう一度ビルドしてみる。

```
dvdread demux error: DVDRead cannot open source: /dev/sr0
```

エラーmsg は変化したけど。ググると 

```
% ls -l /dev/sr0
brw-rw---- 1 root cdrom 11, 0 12月  9 21:30 /dev/sr0
```

なのでグループに追加してみる。

これでうまくいった。もしかして libdvdxxx 無しでも動くのかもしれない。

<!-- vim: set tw=90 filetype=markdown : -->

