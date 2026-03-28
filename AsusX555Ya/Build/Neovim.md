# Neovim-0.3.5

```
make -j4 V=1 CMAKE_INSTALL_PREFIX=/usr \
CMAKE_C_FLAGS='-O2 -fprofile-generate=/sources/gcda/neovim-0.3.5' \
CMAKE_EXE_LINKER_FLAGS='-fprofile-generate=/sources/gcda/neovim-0.3.5' \
CMAKE_BUILD_TYPE=Release  \
CMAKE_C_COMPILER=clang 
```

CMAKE某は適当にディレクトリ作って ``ccmake ..``  で調べた。

なぜか ``make CMAKE_INSTALL_PREFIX=/usr install`` しても /usr/local に放りこまれる。まいっか。


<!-- vim: set tw=90 filetype=markdown : -->
