# Shutdown スピードアップしたい

```
# shutdown のたびに作る必要なし。そもそも initramfs 不要のカスタムカーネルメインだし
systemctl mask mkinitcpio-generate-shutdown-ramfs.service

# ramdisk なんだから電源切るだけで勝手に消える
systemctl mask systemd-tmpfiles-clean.timer
systemctl mask systemd-tmpfiles-clean.service
```



<!-- vim: set tw=90 filetype=markdown : -->

