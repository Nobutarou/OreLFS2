# Windows10 相手にベンチマーク

phoronix-test-suite を使用。あっちは ATi 謹製ドライバーだが、こっちはオープンソースドライ
バーだぞ（fglrx が使用不可なだけだけど）

## LightsMark 

3D レンダリングのベンチマーク. かなりきれいなベンチマーク。

http://openbenchmarking.org/result/1703206-RI-LIGHTSMAR27

Mesa-17.0.1 により、ついに Open Source ドライバーが勝利。

ただしその後、xorg-server と xf86-drivers も最新に上げたら、xorg.conf をどんなにいじっても
105 FPS くらいにしかならなくなった。それでも大分よくなってるけど

## Nexuiz 

FPS ゲー。あんまりきれいな画面じゃない。オープンソースらしい。

http://openbenchmarking.org/result/1703123-TA-NEXUIZLIN67

1.2 倍の性能で Linux 勝利。同類の OpenArena も Linux が勝つ。

## GPU test

一般的なテスト？

http://openbenchmarking.org/result/1703148-RI-GPUTESTSU74

Plot3D と Piano は 15% で Win10 の勝利。Plot3D は負けはしたものの Linux でもスムーズに動く
。Piano はスコア以上に差がある。Win10 はずっと同じテンポでカクカクするが、Linux は、カクカ
クカク、停止、カクカクカク、停止、とこれがもしゲームだったら、相当ストレスが溜まるだろう。

Furmark と Pixmark Volplosion はほぼ引き分け。ただし、Linux は、カクカクカク停
止カクカクカク停止でストレスあり。正直スコアの付けかたが分からない。

Triangle は Linux が大差で勝利。ただこれ、三角形を表示しつづけるという意味不明なベンチなの
で、これに勝ってもなんだか。

他のは fglrx じゃないと動かない。

## Unigine Heaven

Phoronix のだと、不明な GPU みたいな感じになり CPU 処理になる模様なので、普通に測定。普通
に html にログを保存してくれる。

1366x768, Quality=Low, 後は全部 off で

| System                             | Average FPS | Min FPS | Max FPS |
|Linux Mesa17.0.1                    | 14.8        | 6.5     | 22.5    |
| ↑ via weston                      | 15.0        | 10.5    | 23.7    |
|Windows10, DirextX 11               | 15.9        | 8.8     | 26.5    |
|Windows10, OpenGL                   | 15.3        | 6.8     | 31.5    |

まずまず健闘したんじゃないかな。以下は Linux 版のログ. Unknown GPU てなんだよ。Weston 経由
だと Min FPS が改善。ちなみに dpm は default の balanced だけじゃなく performance もやった
けど、まったく変化なし。負荷が高いときは無関係のようだね

https://www.dropbox.com/s/8wzr0q8m40rlodr/Unigine_Heaven_Benchmark_4.0_20170320_0143.html

800x600 だと、差が出てしまう

| System                             | Average FPS | Min FPS | Max FPS |
|Linux Mesa17.0.1                    | 24.5        | 7.8     | 41.5    |
|Windows10, DirextX 11               | 28.6        | 11.9    | 52.4    |

Min FPS の上がらなさが雑魚い。Linux ログは

https://www.dropbox.com/s/ubxnktgn3h7pv4f/Unigine_Heaven_Benchmark_4.0_20170320_0256.html

# Geek Bench 4

CPU ベンチしか Linux ではできない。これは Linux が Windows よりも優位かどうかを見たいわけ
じゃなくて、システム設定やカーネルコンフィグに致命的なミスがないかどうかを調べたかったから
、やってみた。

https://browser.geekbench.com/v4/cpu/2141423
https://browser.geekbench.com/v4/cpu/2141518

Linux の勝ちだけど、Avast のホワイトリストに登録するとどうなるかな。
<!-- vim: set tw=90 filetype=markdown : -->
