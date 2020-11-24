# 必ず宝箱を落すチート

FCEUX の Linux 版はチート用の GUI はなく CUI のみ。FCEUX で DQ3 を起動したら F1 を押して、
CUI を起動。以下

```
2) New Cheats...

7) Add Game Genie Cheat

Command> 7
Name: takarabako
Code: AENLXAYA
Add cheat "takarabako" for code "AENLXAYA"?(Y/N)[N]: Y
Cheat added.
```

すると $HOME/.fceux/cheats/{romのファイル名}.cht というテキストファイルができていて

```
SCb8f2:00:07:takarabako
```

こんな感じになっている

# チートのオンオフ

```
Command> 1
 1) * S $b8f2:000:007 - takarabako
 <'Enter' to make no selection or enter a number.> 1
 <(T)oggle status, (M)odify, or (D)elete this cheat.> t
Cheat 1 disabled.
```

* で始まっている場合は有効。こんな感じで切り替えられる。



<!-- vim: set tw=90 filetype=markdown : -->

