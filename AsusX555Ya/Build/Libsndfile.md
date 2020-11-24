# clang 注意

clang で pgo ビルドすると一回目のビルドの段階で、

```
pulseaudio: /usr/lib/libsndfile.so.1: no version information available (required by /usr/lib/pulseaudio/libpulsecore-12.2.so)
```

のエラーとなる。

<!-- vim: set tw=90 filetype=markdown : -->
