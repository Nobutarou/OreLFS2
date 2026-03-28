# Ecryptfs 使いかた

ecryptfs-utils に fsck.ecryptfs があり、普通に

```
mount -t ecryptfs cipher plain
```

が出きるけど、非 root ユーザーが簡単にできるようにするために ecryptfs-simple
を使う。ecryptfs-simple
はユーザーでもマウントできるようにするのと、いろんなオプションを覚えておいてくれるようにできる。

```
# 最初に passphrase を覚えさせる必要がある
# 失敗するけど気にしない
ecryptfs-setup-private --nopwcheck --noautomount 

# 不要なフォルダができるので消す
rm -frv ~/.Private ~/.ecryptfs

# ecryptfs はマウント時の設定をファイルごとに書きこむらしく、ほうっておくと毎回聞かれる。
# 毎回設定を変えるとは思わないので覚えさす
ecryptfs-simple -a ciper plain

# あれこれ聞かれる。
# filename encryption は趣味で y にする。
Mounting /home/snob/Downloads/ciper on /home/snob/Downloads/plain
Select key type to use for newly created files:
 1) passphrase
 2) openssl
Selection: 1
Passphrase: Select cipher:
 1) aes: blocksize = 16; min keysize = 16; max keysize = 32
 2) blowfish: blocksize = 8; min keysize = 16; max keysize = 56
 3) des3_ede: blocksize = 8; min keysize = 24; max keysize = 24
 4) twofish: blocksize = 16; min keysize = 16; max keysize = 32
 5) cast6: blocksize = 16; min keysize = 16; max keysize = 32
 6) cast5: blocksize = 8; min keysize = 5; max keysize = 16
Selection [aes]:
Select key bytes:
 1) 16
 2) 32
 3) 24
Selection [16]:
Enable plaintext passthrough (y/n) [n]:
Enable filename encryption (y/n) [n]: y
Filename Encryption Key (FNEK) Signature [1a0febef4b7bf924]:

# 一旦 umount
ecryptfs-simple -u plain

# パスワード打ち込みだけでマウントしたいなら
ecryptfs-simple -a -o key=passphrase:ecryptfs_passthrough=n  ciper plain

# パスワード入力なし
ecryptfs-simple -a -o key=passphrase:passphrase_passwd=hogehoge:ecryptfs_passthrough=n  ciper plain
```

一旦できたのだけど、ログアウトしたらできなくなってしまった。ギブアップ

<!-- vim: set tw=90 filetype=markdown : -->

