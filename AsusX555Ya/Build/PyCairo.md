# 1.18.2

なぜか CC=clang としても最後の最後で gcc を使うので、最初から gcc でやる。 

DESIDIR の替りに --root を使う。

```
python setup.py install --skip-build --root="${pkgdir}" --optimize='1'
```

pkg-config の pycairo.pc の prefix が /usr ではなく ${pkgdir} になってしまうので手修正。

<!-- vim: set tw=90 filetype=markdown : -->
