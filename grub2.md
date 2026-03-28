# Grub2

## win10 update で rescue mode に入ってしまったら

```
# パーティションをさがす
ls

# これだと思うパーティションにが、たとえば (hd0, gpt7) だと思ったら
set root=(hd0,gpt7)
set prefix=(hd0,gpt7)/boot/grub

# パーティションがただしければ、エラーが出ない
# エラーが出たら他のパーティションでやりなおし
insmod normal

# grub menu 起動
normal
```

で、↓の方に書いてある grub-install をやりなおす

## どの grub を使うか

手持ちのノートは UEFI ブートしかできない。そのため MBR 用のビルドしかしない LFS ビルドの
Grub2 は使えない。

## 一番簡単なやりかた

適当に Ubuntu 系などをインストールして、その Grub を使う。

## 自前で頑張るやりかた

http://www.linuxfromscratch.org/hints/downloads/files/lfs-uefi.txt

に従う。ただしここは LFS 中のビルドができるようなガイドだけど、BLFS 後で十分だ。むしろ、
GUI 環境構築後くらいのほうが、必要なパッケージがおおよそ入っているので楽だ。それまでは、前
述のやりかたでしのぐのが良い。

Grub2 を UEFI プラットフォーム向けにビルドするには、Efibootmgr が必要で、そのために Efivar
が必要と言う感じで、エラーのたびに辿って行けば良い。なお、ヒントでは popt の静的ライブラリ
が必要と書いてあるが、動的だけでちゃんとビルドできている。

カーネルはヒントとちょっと違ってる。コメント参照。

```kernel
CONFIG_EFI_PARTITION=y
CONFIG_EFI=y

# UEFI で直接起動させる分けじゃなければ、STUB は不要
# CONFIG_EFI_STUB is not set

# どうせ AMDGPU KMS の FB に切り替わるんだから不要。
# CONFIG_FB_EFI is not set

# これで /sys/firmware/efi/efivars が見られると思うんだけど。
# ヒントだと手動でマウントしてる。
CONFIG_EFI_VARS=m
CONFIG_EFIVAR_FS=m

# これらは知らない
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_EFI_ESRT=y
# CONFIG_EFI_RUNTIME_MAP is not set
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# CONFIG_EFI_DEV_PATH_PARSER is not set
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_EFI_PGT_DUMP is not set
```

Efi パーティションのマウントは 

```fstab
UUID=827C-B763 /boot/efi vfat defaults,noauto 0 0
```

これで ``/boot/efi/EFI/Microsoft`` みたいになる。

```sh
grub-install --target=x86_64-efi --efi-directory=/boot/efi  \
--bootloader-id=LFS --recheck --debug
```

で、無事 ``/boot/efi/EFI/LFS/grubx64.efi`` とインストールされるから、バイオスで選べる。

## Grub.cfg

LFS ユーザーは全部手で書く。

```grub.cfg
set default=0
set timeout=10

# どうも自動的に必要なモジュールをロードするみたいだから本当に要るのか分からない
insmod gzio
insmod part_gpt
insmod ext2
insmod efi_gop
insmod search_fs_uuid
insmod font
# 和文フォントも使えるが、標準テーマの枠線がずれる
# 和文使いたいならテーマで罫線消しちゃうほうが楽
loadfont /boot/grub/fonts/terminus-18.pf2

# 一番高い解像度になるみたい
set gfxmode=auto
insmod gfxterm
set gfxpayload=keep
terminal_output gfxterm

# theme を使うときは insmod png しないと画像を読み込まない
# gfxmenu は多分自動でロードされる
# テーマに入ってるフォントをロードしたければ、手動で行なう。set theme はやってくれない。
insmod gfxmenu
insmod png
set theme=/boot/grub/themes/poly-light/theme.txt
export theme

# アイコン使いたいなら class を使う。この場合, lfs.png を使う。
menuentry 'iMac-4.15.18' --class lfs {

  # search で UUID や LABEL を使える。set root=(hd0,1) みたいに usb
  # 差すと変わるようなものは使わない。
  search --no-floppy --fs-uuid --set=root af4065f3-13c5-4557-bc90-60178349eed7

  # UUID や LABEL は ファイルシステムに書きこまれてるのでカーネル起動後にしか使えない。
  # ネットで root=UUID= みたいなのは initrd で事前に同じカーネルを起動済み。
  # PARTUUID はパーティションそのものに書きこまれてるのでカーネル起動時にも使える。
  linux /boot/vmlinuz-4.15.18 \
  root=PARTUUID=6e4f399f-eaf2-46d9-9d81-a122c7ecd5d2 \
  rootfstype=ext4 \
  amdgpu.cik_support=1 radeon.cik_support=0 \
  amdgpu.si_support=1 radeon.si_support=0 \
  amdgpu.dc=1
}

menuentry 'Windows10' --class windows {
  insmod fat	
  insmod chain
	search --no-floppy --fs-uuid --set=root 7CDE7F79DE7F2B12
  chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}

# これは絶対書いておいたほうが良い。
menuentry 'Bios' {
	fwsetup
}

menuentry 'Halt' {
	halt
}

menuentry 'Reboot' {
	reboot
}
```   


<!-- vim: set tw=90 filetype=markdown : -->

