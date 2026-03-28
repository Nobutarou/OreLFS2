# 便利にする

## ホームページ

duckduckgo の検索フォーム付ける

```
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<title>Bookmark</title>


</head>
<body>
  <form action="https://duckduckgo.com" method="GET">
    <p>duckduckgo
    <input type="hidden" name="kp" value="1" />
    <input type="hidden" name="k1" value="-1" />
    <input type="hidden" name="kt" value="n" />
    <input type="hidden" name="kx" value="9e0000" />
    <input type="hidden" name="k5" value="2" />
    <input type="hidden" name="kk" value="-1" />
    <input type="text" name="q" />
    <input type="submit" />
    </p>
  </form>

  <p>
    <a href="/sources/blfs/index.html">blfs</a>
    <a href="/home/snob/_bitbucket/nobutarou_nosuke/zatta/LarizaHome.html">home</a>
    <a href="https://mail.google.com/mail/u/0/#inbox">gmail</a>
    <a href="/sources/lfs/20200319-systemd/index.html">lfs</a>
    <a href="https://outlook.office.com/mail/inbox">owa</a>
  </p>

  <ul>
    <li>alt-q タブを閉じる</li>
    <li>alt-w ホームページ</li>
    <li>alt-e タブを開く</li>
    <li>alt-r 再読み込み</li>
    <li>alt-d ダウンロードマネージャー</li>
    <li>alt-l ロケーションバー</li>
    <li>alt-k 検索</li>
    <li>alt-2/3 次・前を検索</li>
    <li>alt-c 証明書を再読み込み</li>
    <li>alt-a/s タブを左右に切り替え</li>
    <li>F2/F3 履歴を戻る、進む</li>
  </ul>
</body>
</html>
```

## Bookmark Launcher

lariza_bookmark_rofi

```
#!/bin/zsh
BOOKMARKS=/home/snob/_bitbucket/nobutarou_nosuke/zatta/bookmarks.txt
#BROWSER=firefox
BROWSER=OreLariza

URL=$(cat $BOOKMARKS | rofi -dmenu -p bookmark | gawk '{print $2;}')

case $URL in
  "") return;;
  *) $BROWSER $URL  ;;
esac
```

これを fvwm で

```
key (lariza) B A M Exec exec lariza_bookmark_rofi
```

とすることで、lariza のみ Alt+B で起動。

## History Launcer

```
LARIZA_HISTORY_FILE=~/.local/share/gocryptfs/plain/laraiza_history 
```

としておいて、

lariza_hisotry_rofi

```
#!/bin/zsh
HISTRY=~/.local/share/gocryptfs/plain/laraiza_history
#BROWSER=firefox
BROWSER=OreLariza

URL=$(cat $HISTRY | rofi -dmenu -p hist)

case $URL in
  "") return;;
  *) $BROWSER $URL  ;;
esac
```

でやはり fvwm で

```
key (lariza) B A M Exec exec lariza_bookmark_rofi
```

## Minimum font size

~/.config/lariza/user-scripts/fonts.js

```
(function() {
//    var a=prompt("Enter the new font-family name:");
  var b=document.getElementsByTagName("*");
  for(var i=0;i<b.length;i++) {
    var style = window.getComputedStyle(b[i], null).getPropertyValue('font-size');
    var fontSize = parseFloat(style); 
    fontSize=Math.max(fontSize, 12);
    b[i].style.fontSize=fontSize + 'px';
//        b[i].style.fontSize="max(12px,1em)";
//    b[i].style.fontSize=(Math.max(12, fontsize)) + 'px';
//        b[i].style.fontFamily=a;
  }
})();
```

<!-- vim: set tw=90 filetype=markdown : -->
