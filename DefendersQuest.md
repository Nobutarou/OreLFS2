# DS4

SDL_GAMECONTROLLERCONFIG か ds4drv で認識するが動作がところどころおかしいし、別に便利でも
ないので、使うのはやめた

# キーボード

どういうわけか XMODIFIERS が邪魔して入力できない

```
unset XMODIFIERS
```

# フォント

'~/GOG Games/Defenders Quest/game/assets/locales/ja-JP/fonts.xml' の中身を自分の好きなフォ
ントにする。良く分からないが replace 側は fc-list で見れる普通の Linux 的な指定で OK. 

それから、'~/GOG Games/Defenders Quest/game/assets/fonts/verdanab.ttf' のファイル名決め打
ちで使われているので、この ttf を自分の好きな日本語入りのフォントにすれば文字化けも解消す
る。

<!-- vim: set tw=90 filetype=markdown : -->

