# Boot スピードアップしたい

とりあえずカスタムカーネルで Initramfs 使わない

boot パラメータ
```
mitigations=off random.trust_cpu=on fsck.mode=skip usbcore.autosuspend=-1
```



<!-- vim: set tw=90 filetype=markdown : -->

