# カーネル

```
CONFIG_IA32_EMULATION=y
```

# Build refference

http://www.clfs.org/view/CLFS-3.0.0-SYSTEMD/x86/

を参考に 32bit 環境を作ろう

# Environment variables

```
export PATH=/cross-tools/bin:$PATH
export CLFS=/clfs
export CLFS_HOST=x86_64
export CLFS_TARGET="i686-pc-linux-gnu"
```

# 5.7 gmp まで

ABI=32 を configure に付けると通らない。とりあえず ABI=64 のまま通してみる

<!-- vim: set tw=90 filetype=markdown : -->
