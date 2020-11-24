# Kernel

# CC の通し方

なぜか export CC してても通らないので、``make CC=blabla`` する必要がある。KCFLAGS は
export してれば通る。

# 5.5.7

```
KCFLAGS="-mavx -mf16c -msse4 -msse4.1 -msse4.2 -O1 -fgcse -fpredictive-commoning\
-ftree-loop-vectorize"
```

でビルドすると起動できない。一つ一つ消して試す。-O3 でしか入らない最後の二つが怪しい。

- -ftree-loop-vectorize なしは、動かない。
- -fpredictive-commoning なしは, 動かない。
- -m なしは動く
- -mavx 有り, 他の -m 無しは動かない
- -mavx 無しは動かない
- -mf16c のみは動かない
- -msse4 のみは動かない

なぜ -march=native でこれまで動いてたのかが謎だ。仕方ないから -m は使わないことにする。

# Kernel 4.7.2
## GCC-7-20160608 

KCFLAGS なしで落ちる。どうも https://is.gd/nUpwhT らしい。4.12-rc2 にパッチが当たってるこ
とを確認した。

## GCC-6.2 installed in /usr/bin 

### 素のビルド

これまでもしてたし、もちろんできる

### -march=native 足すと？

KCFLAGS に足しても出きた。

``
  gcc -Wp,-MD,scripts/mod/.devicetable-offsets.s.d  -nostdinc -isystem /usr/lib/gcc/x86_64-pc-linux-gnu/6.2.0/include -I./arch/x86/include -Iarch/x86/include/generated/uapi -Iarch/x86/include/generated  -Iinclude -I./arch/x86/include/uapi -Iarch/x86/include/generated/uapi -I./include/uapi -Iinclude/generated/uapi -include ./include/linux/kconfig.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -std=gnu89 -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -m64 -falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_FXSAVEQ=1 -DCONFIG_AS_SSSE3=1 -DCONFIG_AS_CRC32=1 -DCONFIG_AS_AVX=1 -DCONFIG_AS_AVX2=1 -DCONFIG_AS_SHA1_NI=1 -DCONFIG_AS_SHA256_NI=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -fno-delete-null-pointer-checks -O2 --param=allow-store-data-races=0 -Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -Wno-unused-const-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-var-tracking-assignments -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -Werror=date-time -Werror=incompatible-pointer-types -DCC_HAVE_ASM_GOTO -march=native -O2    -DKBUILD_BASENAME='"devicetable_offsets"' -DKBUILD_MODNAME='"devicetable_offsets"'  -fverbose-asm -S -o scripts/mod/devicetable-offsets.s scripts/mod/devicetable-offsets.c awk '!x[$0]++' init/modules.builtin usr/modules.builtin arch/x86/modules.builtin kernel/modules.builtin certs/modules.builtin mm/modules.builtin fs/modules.builtin ipc/modules.builtin security/modules.builtin crypto/modules.builtin block/modules.builtin drivers/modules.builtin sound/modules.builtin firmware/modules.builtin arch/x86/pci/modules.builtin arch/x86/power/modules.builtin arch/x86/video/modules.builtin arch/x86/ras/modules.builtin net/modules.builtin lib/modules.builtin arch/x86/lib/modules.builtin virt/modules.builtin > ./modules.builtin
``

のように有効になっている。

### -lfto 足すと

これは手も足も出なそう. 次のようなエラーが次々と出ている。

``
In file included from include/linux/gfp.h:5:0,
                 from include/linux/slab.h:14,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets.c:8:
include/linux/mmzone.h:341:22: エラー: ‘MAX_NR_ZONES’ がここでは宣言されていません (関数内ではない)
  long lowmem_reserve[MAX_NR_ZONES];
``

### -fprofile-generate は？

エラーが出る。リンカに -lgcov 付けてないからね。どこで付けるのかも分からないから、とりあえ
ず march が乗ったことに満足するか。

``
arch/x86/entry/vdso/vgetcpu.o:(.data.rel+0x60): `__gcov_merge_time_profile' に対する定義さ
れていない参照です: エラー: ld はステータス 1 で終了しました
  objcopy -S  arch/x86/entry/vdso/vdso64.so.dbg arch/x86/entry/vdso/vdso64.so
  objcopy: 'arch/x86/entry/vdso/vdso64.so.dbg': そのようなファイルはありません
  make[3]: *** [arch/x86/entry/vdso/Makefile:124: arch/x86/entry/vdso/vdso64.so] エラー 1
  make[2]: *** [scripts/Makefile.build:440: arch/x86/entry/vdso] エラー 2
  make[1]: *** [scripts/Makefile.build:440: arch/x86/entry] エラー 2
``

<!-- vim: set tw=90 filetype=markdown : -->
