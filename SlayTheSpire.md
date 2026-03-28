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

# GOG 版 mod 入れ方 (obso, 残念だけど入れられなくなった)

https://www.reddit.com/r/slaythespire/comments/gj5kel/howto_add_mods_to_gog_version/

が更新されている。

https://steamworkshopdownloader.io/

に steamcmd が必要になった。面倒なので Windows で DL することにしよう

# GOG 版 mod 入れ方 (obso, 残念だけど入れられなくなった)

https://www.reddit.com/r/slaythespire/comments/gj5kel/howto_add_mods_to_gog_version/

1. https://steamworkshopdownloader.io/ で以下の 3個を DL

https://steamcommunity.com/sharedfiles/filedetails/?id=1605060445&searchtext=
https://steamcommunity.com/sharedfiles/filedetails/?id=1605833019&searchtext=
https://steamcommunity.com/sharedfiles/filedetails/?id=1609158507&searchtext=

2. ModtheSpire.jar を <install_dir>/game に置く。ここには desktop-1.0.jar があるはず。

3. ```java -jar ModtheSpire``` で mods フォルダが現れる。java は java8 が必要。最新の java17 では駄目。

4. mods フォルダに BaseMod.jar, StSLib.jar を入れる。

5. ModtheSpire を終了して、好きな mod を mods フォルダに入れる。

6. ModtheSpire を起動して遊ぶ。

<!-- vim: set tw=90 filetype=markdown : -->
