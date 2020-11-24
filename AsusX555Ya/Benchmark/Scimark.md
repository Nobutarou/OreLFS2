# GCC 9.3.0 まとめ

clang O2 native pgo >= gcc O2 pgo > clang O2 native >> gcc O1+m個別 (次節) > gcc O1 (次節)
>> gcc O2 native

Kernel は m 付けると不安定なことがあったので gcc O1 m無しで、普段は clang O2 native か gcc
O2 pgo で良さそうだ

# Scimark2 でどの CFLAGS が効いているのか確かめる

まず、 -O1 が -O2 を上回るので、どれが効いているか調べた。-O1 よりも 2% 以上上回るのは、
-fgcse のみだった。ついでに -O3 のオプションも比較。効果があるのは 
-fpredictive-commoning と -fpredictive-commoning だけだった。こちらは両方とも
-fprofile-use で有効化される。

```
export CFLAGS="-O1 -fgcse -fpredictive-commoning -ftree-loop-vectorize"
```

となった。

そして -march=native を付けると下回るので、やはり一つずつ効果を確認。 -mavx, -mf16c,
-msse4, -msse4.1, -msse4.2 が +2% 以上の効果を示した。なのでこうなった

```
export -mavx -mf16c -msse4 -msse4.1 -msse4.2 -O1 -fgcse -fpredictive-commoning\
 -ftree-loop-vectorize
```

なお、-fprofile-generate の段階では -m は不要で -fgcse のみ付ける

<!- -vim: set tw=90 filetype=markdown : -->
