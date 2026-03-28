# Btrfs を ループバックデバイスにマウントする

HW のインストールサイズがでかすぎ問題に対処するため、btrfs でループバックデバイスをマウン
トし圧縮を掛ける。btrfs 開発者は lz4 に対応する気がないとのことなので zstd で軽く圧縮する
。

```
fallocate -l 26G ~/.local/share/diskimg/btrfs01.img
sudo losetup /dev/loop0 ~/.local/share/diskimg/btrfs01.img
sudo mount -o compress=zstd:1,user,rw /dev/loop0 $HOME/2019 
```
