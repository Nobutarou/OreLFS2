# GCBASIC メモ

PIC マイコンのオープンソースなコンパイラ

https://gcbasic.sourceforge.io/Typesetter/

## インストール方法

基本的にここに従うのだけど、一部修正や、やらなくて良いことがある。

https://gcbasic.sourceforge.io/Typesetter/index.php/Install-GCBASIC-for-Linux

### 1, FreeBasic のインストール

どうも Basic 自体の部分は FreeBasic というものらしい。

ここから最新版を DL して

https://sourceforge.net/projects/fbc/files/

root ユーザで、インストールする。インストールパスを指定しないと /usr/local にそのまま入る
ので、何が FreeBasic で何がそうでないのか不明になってしまう。

```sh
./install.sh -i /opt/FreeBASIC-1.10.1
```

``sudo`` が好きならそうして。

<インストール dir>/bin を PATH に加えておく。

### 2, GC Basic のビルドとインストール

ここから最新の rar をダウンロードする。

https://sourceforge.net/projects/gcbasic/files/GCBASIC%20-%20Linux%20Distribution/

rar ファイルのパスワードは GCB。同じページに書いてある。何か理由があるそうだけど知らん。

```sh
cd linuxbuild
chmod +x install.sh
./install.sh build
```

それで install.sh に書いてあるパスが間違っているのか unrar が大文字小文字区別できていない
のかで、ディレクトリ名を修正する必要がある。

```sh
mv -v supportfiles SupportFiles
cd ..
mv -v linuxbuild LinuxBuild
cd -
```

これで root にて

```sh
./install.sh install
```

これで /opt/GCBASIC にインストールされる。ディレクトリがあるとエラーになるので、消しておく。
/opt/GCBASIC を PATH に加えておく。

これで終り。なぜか MPLABX と Geany とかいうエディタをインストールするように書いてあるが不
要。

## 使ってみる

```
; pic12f1501 with 4MHz
#Chip 12f1501,4

; The default is LVP = OFF. Very dangerous.
#config LVP = ON
#config MCLR = ON

#Define LED PortA.5

Dir LED Out

Do
  LED = !LED
  Wait 500 ms
Loop
```

とか書いて、これで hex ファイルを作れる。

```
gcbasic /A:GCASM hoge.c
```

LVP=OFF は危険だと思うんだけど。。。
