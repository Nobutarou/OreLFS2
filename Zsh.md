# 設定ファイルについて

全ユーザーへの設定は /etc/zshhogehoge ということになっているけど、BLFS 版は /etc/zsh/ 以下のファイルを読むことになっているから注意 

# gpg2 について

gpg2 用の補完はまだ出きてないみたい. 
```zsh
compdef gpg2=gpg
```
で gpg 向けの補完機能が使える

<!-- vim: set tw=90 filetype=markdown : -->

