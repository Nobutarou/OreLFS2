# Boot スピードアップしたい

とりあえずカスタムカーネルで Initramfs 使わない

boot パラメータ
```
mitigations=off random.trust_cpu=on fsck.mode=skip usbcore.autosuspend=-1 \
kernel.dmesg_restrict=0 loglevel=3 audit=0 sysrq_always_enabled=1 amdgpu.aspm=0 \
ipv6.disable=1 amdgpu.ppfeaturemask=0xfff7ffff
```



<!-- vim: set tw=90 filetype=markdown : -->

