# Terminal Emulator の旅

## Xfce4-Terminal

どうも Fglrx にしたころから、wget とか make が終っても、表示が更新されなくなった。マウスを
ひょいと動かすと更新されるので、Fglrx がらみだよなあ。

ssh とか使わないから、単にタブ使えるだけの、このシンプルなターミナルで良いんだけど、他もち
ょっと触ってみることにした。

利点:

## xterm

いつ入れたかな。BLFS のビルドだと 256 色が無効になってるので --enable-256-color で有効にし
てみる。

xterm の細大の弱点は設定が面倒なこと。こういう時は arch が本当に役に立つ。

  https://wiki.archlinux.org/index.php/Xterm

--> それでも面倒すぎる。やめた

## rxvt

参考になるのは、やはり、arch.

  https://wiki.archlinux.org/index.php/Rxvt-unicode

perl の拡張でクリップボードまわりや、タブなんかも強化されている模様。

xft フォントが使えるのだけど、pcf フォントは指定した通りにならない。pcf フォントは昔ながら
の fonts.dir に従う必要があるようだ。 --> フォントファイル壊れてたから真偽は不明。

256 色は --enable-256-color を明示しないと行けない。--enable-everything は 88 色まで。
色テーマは urxvt jellybeans でググるとか、github で xresourcs を探してコピペ。

im のフォントがおかしい。URxvt*imFont で fonts.dir の書式で m+ を指定すると文字化けで、xft
で書くとエラーになる。仕方ないので、uim 側で xim のフォントを指定したらうまく行った。

--> xim-onthespot というモジュールを使うとうまく行きそうだぞ。

URxvt*lineSpace で行間を変えられるのは便利。xfce4-terminal には無い。ちょっとゆったりさせ
られる。

arch に載っている url-select というモジュールはこちら。これで url をブラウザで表示できるし
、クリップボードにもコピーできる。alt-u で選択モードになる。マウスでも操作できる。

	https://github.com/muennich/urxvt-perls

標準の tabbed でタブが使える。キーの変更は出きない模様。shift-down で new tab 
とかやだな、なんか vim と被りそうで。tabbedex は

	https://github.com/mina86/urxvt-tabbedex

から入手できて、キーバインドを変更できる。vim があまり使わない alt で操作できるようにしよ
う。マウスも使える。

クリップボードは、マウスで選ぶと PRIMARY に入り、ctrl-alt-c で CLIPBOARD に入る。
ctrl-alt-v で CLIPBOARD からの入力が出きる。これも clipboard という拡張でキーバインド変更
できるけど、ま、良いかな。下手に ctrl-shift-何とかとかして vim と被ったりすんのやだし。

設定は面倒だけど、なんだかめちゃくちゃ細かい設定ができそうだ。/usr/lib/urxvt/perl を覗いて
みたり github で探すのも面白そう。

でもなんだろう。less や vim でページめくりしたとき、表示が崩れるんだよな。なんかドットが残
っちゃって汚いというか。英文だけのファイルは崩れないので、フォントの問題だと思う。もともと
jix だかなんだかの m+ を誰かが iso10646 に変換したものを使ってるので、それが悪さをしてるの
かも。

--> ここのフォント使ったら上手く行きそう。でもボールドないんだよなぁ 

  http://www.xmisao.com/2013/08/17/mplus-unicode-font.html 

--> ここのやり方でボールドも作れた。ついでに可変幅フォントも作ったので、全部 fonts ディレ
クトリに置いておく。

永らく使ってきたが tmux を使うようになって、長いテキスト処理の遅延がむごく、また新たな旅に
出る予感。ま tmux 使わずにタブを使えば良いんだろうけど

zsh の time で計測してみる

```zsh
time porg -f boost
# boost は非常に多くのファイルをインストールする
```

```
porg -f boost  0.11s user 0.04s system 1% cpu 14.436 total
```

とても長い。

```zsh
# xterm だと
porg -f boost  0.10s user 0.03s system 11% cpu 1.162 total
```

```zsh
#terminator だと
porg -f boost  0.10s user 0.05s system 10% cpu 1.362 total
```

一桁遅い。

そこで jump scroll と skip scroll を知り有効にしてみたけど変化なし。stdbuf -o0 というのを
付けてみたけど変化なし。line space 0 も効果なし。
さらに 

```configure
--prefix=/usr --enable-everything --enable-256-color --disable-xft --disable-afterimage --disable-pixbuf
```

で xft や画像サポートを外してみたけど、それでも変化なし。perl extension はずしたら

```zsh
porg -f boost  0.10s user 0.03s system 1% cpu 11.547 total
```

うんまあちょっと速くなったけど、焼け石に水

でもまあなんだかんだで戻ってきてる。自分には tmux いらないや。

で --enable-pixbuf 付けないと、.configure の画面では puxbuf サポートするみたいに出てるけど
、実際はサポートされない。そのためにアイコンの変更も出きない。tint2 が変なアイコン出すのを
、しばらく tint2 と sawfish の問題だと思って解決に時間がかかった。

## st

config.h でいちいちコンパイルが必要なのが糞. xim が off the spot のみなのも糞。

## Terminator

vte というか、おそらく cairo の表示バグがなくなってればこれが一番かな。

## Xfce4-Terminal

分割は出きないので tmux と一緒に使うことになりそう。でこれは vte 系はどれも同じかもしれな
いけど、alt がプルダウンメニューに取られるので、tmux のプレフィックスキーにはできない。そ
れから素の機能で使うとするとタブを活用することになるが、何故かタブが 3 行くらいの高さにな
るのが不恰好。まあ Vte 系なら Terminator で良いとなるね。

## mlerm

昔、kterm から乗り換えて使ってたなあと思ってなんとなく検索したら、今でも開発が続いているこ
とが分かり試してみることに。

初期に ctrl-mouse3 でメニューが出ないというトラブルに見舞われたけど、shift-f9 とかに割り当
て直して解決。その際、/usr/etc/mlterm 配下のファイルを全部コピーしたけど、GUI は項目によっ
ては変な書き込み方をして、変更が無効になってしまうので、その際は設定ファイルを直接編集。

で使ってみると、なんだかこれは凄い。tmux みたいに縦横分割もできるし、タブみたいな機能 pty
と言うのもある。

おー ansi 16 色だけじゃなく、256 色全て指定できる。これで base16 テーマをフルに使える。

<!-- vim: set tw=90 filetype=markdown : -->

