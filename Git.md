# 履歴を消してフォルダを軽くする

## .git を rm -fr するシンプルな方法

```
rm -fr .git
git init
git add .
git commit -m "Re-initialize repository"

# github のページからコピーするのが確実
git remote add origin git@github.com:User_Name/Repo_Name.git
git branch -M main
git push -u origin main --force
```

## 履歴を圧縮？する方法

```
git gc --prune=now --aggressive
```

<!-- vim: set tw=90 filetype=markdown : -->

