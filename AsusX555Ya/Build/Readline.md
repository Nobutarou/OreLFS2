# 8.0

gcc で pgo 一回目. どうもおかしい。bash は最初 /tools に tar ball に含まれる readline でビ
ルドしたから OK だけだったようだ。

```
/bin/bash: symbol lookup error: /usr/lib/libhistory.so.8: undefined symbol: __gcov_time_profiler_counter
```

clang に期待しよう。

<!-- vim: set tw=90 filetype=markdown : -->
