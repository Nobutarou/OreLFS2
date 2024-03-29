# USB 周辺機器の電流値を調べる

まずは接続したいデバイスの電流値を知らなくてはならない。

実は Linux などの OS から調べる手段はない。メーカーがデバイスに最大電流を書きこんでいて
lsusb などで調べられるそうだが、あてにはならない。

なので物理的に調べる必要がある。物理的に調べるには Aliexpress で USB 電流測定器を買おう。
自分が持ってるのはこれだ。

https://www.aliexpress.com/item/32812735435.html?spm=a2g0s.9042311.0.0.27424c4dfnpsvP

ただいろいろ似たものがあるので、USB ハブとしてちゃんと機能するのか、充電器にしか対応してな
いのか、そのあたりの見分け方は全然分からない。たまたま、充電器用に買ってあったのが、USB ハ
ブとしても動いたというだけなので。

# 実際の電流値

ハブに繋ぎたいと思うものを、適当に測ったときの最大値. A で表記

| マウス         | Delux m618 mini              | 0.034 |
| キーボード     | Filco Majestouch Hakua       | 0.015 |
| サウンドカード | Sound Blaster Play 3         | 0.085 |
| Web カメラ     | Creative Live Cam Sync 1080p | 0.215 |

全部足しても 0.349A

# PC 側を何タイプにするか

Lenovo S340 14インチの type-c は、Display 何とかでもなく、PD でもないので、ただの type-c.
そもそも使ってもいないし、特別な使い道もないので、潰して問題なし。ということで type-c とす
る。type-c は規格上 1.5A 流せるので、いくら Lenovo がけちっても 1.5A は流せるだろう。十二
分にお釣りが来る。

# 転送規格はどうするか

繋ぎたいものはすべて USB2.0 以下のものなので 2.0 で十分.

# 自分の選択

先を見越したところで、そのときには別のものが主流かもしれないから、今必要なものだけで十分で
ある。となると type-c usb2.0 で 0.5A 程度流せるもので、好きな Elecom, J5 create, Transcend
から選べば良い。

<!-- vim: set tw=90 filetype=markdown : -->

