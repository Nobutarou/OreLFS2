# 3.8.2

```
--enable-optimizations
--with-lto
```

# Python3 の FDO ビルド

``
--enable-optimizations
``

# module path

graft を使うと、${DESTDIR}${PREFIX}/usr/lib/python3.x/site-packages にモジュールパスが設定
されてしまうので ${DESTDIR}${PREFIX}/usr/lib/python3.x/site-packages に hoge.pth というフ
ァイルを 

``
/usr/lib/python3.x/site-packages 
``

という中身で作れば解決。確認は python3 の中で

``
import sys
sys.path
```

で

<!-- vim: set tw=90 filetype=markdown : -->
