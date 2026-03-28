# Sudo プロンプト調整

visudo で
```visudo
Defaults passprompt="%u password: ",pwfeedback
```
のようにする。前者はプロンプトの変更。後者はアスタリスクを入力中に表示。パスワードの長さを
他人に知られてしまう恐れがある。

# 順番
上から順に上書きされる。なので全コマンドをパスワード付で許可したあとで、NOPASS を設定しな
いといけない。逆にすると NOPASS が消える。

<!-- vim: set tw=90 filetype=markdown : -->

