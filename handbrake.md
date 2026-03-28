# handbrake-0.10.5 build

## まとめ

へたなことをせず、

```zsh
./configure --prefix=/usr/local
cd build
make -j1
```

でうまく行く。

--enable-local-yasm とかを、システムの yasm を使うことかと思っていたが、どうもダウンロード
してきてコンパイルしなおすとかの意味だったらしい。

## 最初のエラー

```zsh
./configure --launch-jobs=3 --launch --prefix=/usr --enable-local-yasm
--enable-local-autotools --enable-local-cmake
```

などと勘違いして設定してしまうと、以下のようにはまるので厳禁

```gcc

 : make[4]: Entering directory '/sources/HandBrake-0.10.5/build/contrib/m4/m4-1.4.16/lib'
  : \
  : #	source='gl_avltree_oset.c' object='gl_avltree_oset.o' libtool=no 
  : \
  : #	source='c-ctype.c' object='c-ctype.o' libtool=no 
  : \
  : #	source='c-stack.c' object='c-stack.o' libtool=no 
  : /usr/bin/gcc  -I.   -I/sources/HandBrake-0.10.5/build/contrib/include -march=native -O2  -I/sources/HandBrake-0.10.5/build/contrib/include -std=gnu99 -march=native -O2 -c gl_avltree_oset.c
  : /usr/bin/gcc  -I.   -I/sources/HandBrake-0.10.5/build/contrib/include -march=native -O2  -I/sources/HandBrake-0.10.5/build/contrib/include -std=gnu99 -march=native -O2 -c c-ctype.c
  : /usr/bin/gcc  -I.   -I/sources/HandBrake-0.10.5/build/contrib/include -march=native -O2  -I/sources/HandBrake-0.10.5/build/contrib/include -std=gnu99 -march=native -O2 -c c-stack.c
  : \
  : #	source='clean-temp.c' object='clean-temp.o' libtool=no 
  : \
  : #	source='close-hook.c' object='close-hook.o' libtool=no 
  : /usr/bin/gcc  -I.   -I/sources/HandBrake-0.10.5/build/contrib/include -march=native -O2  -I/sources/HandBrake-0.10.5/build/contrib/include -std=gnu99 -march=native -O2 -c clean-temp.c
  : /usr/bin/gcc  -I.   -I/sources/HandBrake-0.10.5/build/contrib/include -march=native -O2  -I/sources/HandBrake-0.10.5/build/contrib/include -std=gnu99 -march=native -O2 -c close-hook.c
  : In file included from clean-temp.h:22:0,
  :                  from clean-temp.c:23:
  : ./stdio.h:477:1: error: 'gets' undeclared here (not in a function)
  :  _GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
  :  ^
```

この行を消せば良いらしい

```zsh
sed -i -e '/gets is a security/d' ./contrib/m4/m4-1.4.16/lib/stdio.h
```

その後、build ディレクトリから make すると同じエラーになるので、そこまで降りてきてから
make する。上書きされてしまうみたい. いやだめだ上書きされちゃう



<!-- vim: set tw=90 filetype=markdown : -->

