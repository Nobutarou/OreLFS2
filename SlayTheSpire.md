# Slay the Spire on Linux 注意点

## start.sh 間違っている


```
 "./jre/bin/java"
```

となっているところをこうする必要がある。

```
 ./jre/bin/java -jar desktop-1.0.jar
```

## xrandr 必要

LFS だと自然に入るが Arch は明示しないと入らない。そして入れないと、

```
Exception in thread "LWJGL Application" java.lang.ExceptionInInitializerError
  at 
```

という、とても xrandr に関係してる感じのしないエラーがでるので、分かりにくい。

<!-- vim: set tw=90 filetype=markdown : -->

