# cmake tips

# verbose output in make

VERBOSE=1 instead of V=1

# デフォルトの cc, c++

デフォルトで /usr/bin/cc /usr/bin/c++ となっているので、PATH を有線していても
/opt/gcc-7/bin/gcc とかを使えない。

ln -sv しておくか CC, CXX を設定しておく必要がある。


<!-- vim: set tw=90 filetype=markdown : -->

