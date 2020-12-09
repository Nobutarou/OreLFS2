# 履歴を消してフォルダを軽くする

新しいレポを作ったりしてたけど、そんな必要ないみたい。

https://support.atlassian.com/bitbucket-cloud/docs/maintain-a-git-repository/

BFG を使うのが楽だった

リポジトリの一つ上で

```
java -jar bfg.jar --strip-blobs-bigger-than 1K <repo folder>
```

そしたら
```
git reflog expire --expire=now --all
git gc --prune=now
git push --all --force
git push --tags --force
```

BFG 本家のやり方だとエラーで push できないので Bitbucket のやり方が良いみたい
https://rtyley.github.io/bfg-repo-cleaner/

<!-- vim: set tw=90 filetype=markdown : -->

