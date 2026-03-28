# 3.51.1

mk ファイル書き変えるとか面倒くさいから pgo しない

clang ではビルド失敗

# 3.51

clang でビルド可能

# Nss-3.50

clang は前回と同じ（ような）エラー。自力修復は無理。

# NSS-3.42.1, Clang で PGO に挑戦するも失敗

次でやってみたけど自力で解決不可能そうなエラーに遭遇するから諦めよう

```diff
--- nss-3.42.1/nss/coreconf/Linux.mk.org        2019-03-03 21:24:03.390280199 +0900
+++ nss-3.42.1/nss/coreconf/Linux.mk    2019-03-03 21:27:34.750279631 +0900
@@ -3,9 +3,9 @@
 # License, v. 2.0. If a copy of the MPL was not distributed with this
 # file, You can obtain one at http://mozilla.org/MPL/2.0/.

-CC     ?= gcc
-CCC    ?= g++
-RANLIB ?= ranlib
+CC     ?= clang
+CCC    ?= clang++
+RANLIB ?= llvm-ranlib

 include $(CORE_DEPTH)/coreconf/UNIX.mk

@@ -110,7 +110,7 @@
 ifeq (11,$(ALLOW_OPT_CODE_SIZE)$(OPT_CODE_SIZE))
        OPTIMIZER = -Os
 else
-       OPTIMIZER = -O2
+       OPTIMIZER = -O2 -fprofile-generate=/sources/gcda/nss-3.42.1
 endif
 ifdef MOZ_DEBUG_SYMBOLS
        ifdef MOZ_DEBUG_FLAGS
@@ -207,3 +207,4 @@
 LDFLAGS += --coverage
 DSO_LDOPTS += --coverage
 endif
+LDFLAGS += -fprofile-generate=/sources/gcda/nss-3.42.1
```
出てくるエラーは

```
Linux4.19_x86_64_clang-7_glibc_PTH_64_OPT.OBJ/secdig.o: 関数 `SGN_CreateDigestInfo_Util' 内:
secdig.c:(.text.SGN_CreateDigestInfo_Util+0x1e1): `__llvm_profile_instrument_range' に対する定義されていない参照です
Linux4.19_x86_64_clang-7_glibc_PTH_64_OPT.OBJ/derenc.o: 関数 `der_encode' 内:
derenc.c:(.text.der_encode+0x36a): `__llvm_profile_instrument_range' に対する定義されていない参照です
derenc.c:(.text.der_encode+0x407): `__llvm_profile_instrument_range' に対する定義されていない参照です
derenc.c:(.text.der_encode+0x453): `__llvm_profile_instrument_range' に対する定義されていない参照です
Linux4.19_x86_64_clang-7_glibc_PTH_64_OPT.OBJ/dersubr.o: 関数 `DER_SetInteger' 内:
dersubr.c:(.text.DER_SetInteger+0xfa): `__llvm_profile_instrument_range' に対する定義されていない参照 です
L
```

# NSS-3.40 Gcc で PGO に挑戦

CC, CFLAGS, LDFLAGS, LIBS が効かないので mk ファイルを直接書き換える。

```diff
--- nss-3.40/nss/coreconf/Linux.mk.org	2018-12-12 00:11:12.831966165 +0900
+++ nss-3.40/nss/coreconf/Linux.mk	2018-12-12 00:12:04.367721035 +0900
@@ -110,7 +110,7 @@
 ifeq (11,$(ALLOW_OPT_CODE_SIZE)$(OPT_CODE_SIZE))
 	OPTIMIZER = -Os
 else
-	OPTIMIZER = -O2
+	OPTIMIZER = -O2 -fprofile-generate=/sources/gcda/nss-3.40 -fprofile-arcs
 endif
 ifdef MOZ_DEBUG_SYMBOLS
 	ifdef MOZ_DEBUG_FLAGS
@@ -133,7 +133,7 @@
 ifeq ($(KERNEL),Linux)
 	OS_CFLAGS	+= -DLINUX -Dlinux
 endif
-OS_LIBS			= $(OS_PTHREAD) -ldl -lc
+OS_LIBS			= $(OS_PTHREAD) -ldl -lc -lgcov
 
 ifdef USE_PTHREADS
 	DEFINES		+= -D_REENTRANT
@@ -207,3 +207,5 @@
 LDFLAGS += --coverage
 DSO_LDOPTS += --coverage
 endif
+
+LDFLAGS += -lgcov
```

これで 1回目は通った。

2回目は

```diff
--- nss-3.40/nss/coreconf/Linux.mk.org	2018-12-12 00:43:08.085425347 +0900
+++ nss-3.40/nss/coreconf/Linux.mk	2018-12-12 00:44:59.935425047 +0900
@@ -110,7 +110,7 @@
 ifeq (11,$(ALLOW_OPT_CODE_SIZE)$(OPT_CODE_SIZE))
 	OPTIMIZER = -Os
 else
-	OPTIMIZER = -O2
+	OPTIMIZER = -O2 -fprofile-use=/sources/gcda/coreconf -fprofile-correction -march=native
 endif
 ifdef MOZ_DEBUG_SYMBOLS
 	ifdef MOZ_DEBUG_FLAGS
@@ -133,7 +133,7 @@
 ifeq ($(KERNEL),Linux)
 	OS_CFLAGS	+= -DLINUX -Dlinux
 endif
-OS_LIBS			= $(OS_PTHREAD) -ldl -lc
+OS_LIBS			= $(OS_PTHREAD) -ldl -lc 
 
 ifdef USE_PTHREADS
 	DEFINES		+= -D_REENTRANT
@@ -207,3 +207,5 @@
 LDFLAGS += --coverage
 DSO_LDOPTS += --coverage
 endif
+
+
```

これで通る。

次は Clang にも挑戦しよう



<!- vim: set tw=90 filetype=markdown : -->
