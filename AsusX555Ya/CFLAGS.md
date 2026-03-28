# Scimark2-1.2.3 と Clang-7.0 でテストしてみた

O2+LTO でおかしな数字を叩き出す。順に O2+LTO+PGO, O2+PGO, O2 の順か。平均値が安定していて
、おかしな O2+LTO 以外の最高値も GCC より高いから、こっちを本命としよう。march=native に魅
力は感じない。

# Scimark2-1.2.3 と GCC-8.2 でテストしてみた

-O123, -march=native の有無、PGO 有無、LTO 有無の合計 24 通りを試してみた。

全ての項目で平均を上まわったのは、

``-O2/3 -march=native -fprofile-use -fprofile-correction -flto``

のみ。スコアが O2 の方良く (879)、安全性、コンパイル速度を考えて、O2 を標準として選択。

ただし、march=native はバグるときもあるので、-1Σ以上も確認。

```
-O3
-O1/2/3 -fprofile-use -fprofile-correction
-O1/2/3 -fprofile-use -fprofile-correction -flto
-O1 -march=native -fprofile-use -fprofile-correction -flto
```

が上る。O1+PGO+LTO が実は最高スコア (890) なので次点はこれ。LTO が動かないときに備えて、
O1+PGO が三位 (862). PGO も駄目なときに備えて O3 が四位。

O3 も危険だから、O2 よりもスコアの高い O1 (622) が最後の砦か。

## まとめ

- Clang_LTO_O2
- Clang_O2_PGOpre
- Clang_LTO_O2_PGOpost
- Clang_O2_PGOpost
- Clang_O2
- GCC_O1_PGOpre
- GCC_O1_LTO_PGOpost
- GCC_O1_PGOpost
- GCC_O1
  
<!-- vim: set tw=90 filetype=markdown : -->
