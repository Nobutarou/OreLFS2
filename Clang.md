# Clang でビルドするには

```
CC=clang
CXX=clang
```

PGO は

```
CFLAGS="-fprofile-generae=folder"
CXXFLAGS="-fprofile-generae=folder"
```

でビルドしてランしたら folder に default_15823292103428789754_0.profraw と言うようなファイ
ルが出きてるので

```
llvm-profdata merge -output=default.profdata default_15823292103428789754_0.profraw
```

のあと

```
CFLAGS="-fprofile-use=folder"
CXXFLAGS="-fprofile-use=folder"
```

となる。

PGO + LTO の場合、一回目は -flto なしで 二回目に -flto 付ける. そうしないと mismatch エラ
ーが出る。

<!-- vim: set tw=90 filetype=markdown : -->

