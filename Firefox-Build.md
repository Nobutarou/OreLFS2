# インストール

```
DESTDIR=hogehoge ./mach install
```

# 76.0.1

--enable-system-sqlite とあるがこれが無効になっている。

nss に関して次の error が出るので、system-nss しないほうが良さそうだ。

```
 5:00.78 make[3]: *** 'netwerk/test/http3server/target' に必要なターゲット 'security/nss/lib/nss/nss_nss3/target' を make するルールがありません.  中止.
 5:00.78 make[2]: *** [/sources/firefox-76.0.1/config/recurse.mk:34: compile] エラー 2
 5:00.78 make[1]: *** [/sources/firefox-76.0.1/config/rules.mk:394: default] エラー 2
 5:00.79 make: *** [client.mk:125: build] エラー 2
 5:00.80 0 compiler warnings present.
=
```

あと Python3 は sqlite モジュールが必要（Sqlite のあとでもう一回 Python3のビルド）


# 73.0.1

``-O3`` が CFLAGS の後に来る。ただでさえビルドが遅いといのに、全く。

```
foreach i in $(grep -rl "\-O3" ./)
do
sed -i "s/-O3/-O2/" $i
done
```

を一括でしてしまうと check sum error が出る。仕方ないので config/moz.build だけ O2 に変更してみ
る。

```
export RUSTFLAGS="-C target-cpu=native"
```
としておく。リリース段階では opt-level=2 で、プロファイル収集段階は 1 のようだ。cargo.toml より。

```
export AR=llvm-ar NM=llvm-nm RANLIB=llvm-ranlib
```

```
ac_add_options --enable-lto
ac_add_options MOZ_PGO=1
```

で

```
515:34.38 /tmp/lto-llvm-779aa8.o: 関数 `mozilla::SandboxBroker::Create(mozilla::UniquePtr<mozilla::SandboxBroker::Policy const, mozilla::DefaultDelete<mozilla::SandboxBroker::Policy const> >, int, mozilla::ipc::FileDescriptor&)' 内:
515:34.38 Unified_cpp_linux_broker0.cpp:(.text.unlikely._ZN7mozilla13SandboxBroker6CreateENS_9UniquePtrIKNS0_6PolicyENS_13DefaultDeleteIS3_EEEEiRNS_3ipc14FileDescriptorE+0x2b): `moz_xmalloc' に対する 定義されていない参照です
515:34.38 /tmp/lto-llvm-779aa8.o: 関数 `mozilla::SandboxBrokerPolicyFactory::SandboxBrokerPolicyFactory()' 内:
515:34.38 Unified_cpp_linux_broker0.cpp:(.text._ZN7mozilla26SandboxBrokerPolicyFactoryC1Ev+0x33): `moz_xmalloc' に対する定義されていない参照です
5
```

となってしまった。lto はあきらめ。pgo のみならビルド成功

```
DESTDIR=/sources/firefox-73.0.1/firefox-73.0.1 ./mach install
```

# Firefox-63.0

Node.js が無くても良いみたいになってるが、実際には無いとビルド途中でエラーが出る。しかもそのエラーで止まらないから、発見が遅れる。

ちなみに公式は gcc-6.4 でビルドされていた。なんか BLFS が 63 からは clang
と言ってるのと違う。

なんか

```
CC=clang
CXX=clang++
CFLAGS=-O2 -fprofile-generate=/sources/gcda/Build
CXXFLAGS=-O2 -fprofile-generate=/sources/gcda/Build
LDFLAGS=-fprofile-generate=/sources/gcda/Build
```

でビルドできてしまった。このときの mozconfig は

```
ac_add_options --disable-dbus
ac_add_options --disable-necko-wifi
ac_add_options --disable-gconf
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --enable-official-branding
ac_add_options --with-system-graphite2
ac_add_options --with-system-harfbuzz
ac_add_options --prefix=$HOME/.local/firefox-63.0
ac_add_options --enable-application=browser
ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-tests
ac_add_options --enable-optimize
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman
ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib
mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/firefox-build-dir
```

で、BLFS のように Linker=Gold 指定はしていない。

で適当にブラウジングしてプロファイルを集めたあと、

```
CC=clang
CXX=clang++
CFLAGS=-O2 -fprofile-use=/sources/gcda/firefox-63.0 -march=native
CXXFLAGS=-O2 -fprofile-use=/sources/gcda/firefox-63.0 -march=native
LDFLAGS=-fprofile-use=/sources/gcda/firefox-63.0
LIBS=
```

でビルド成功。


# Firefox の FDO ビルド

Mozilla source tree doc, https://is.gd/BGzNL2 より

``
ac_add_options MOZ_PGO=1
``

を付けて、

``
./mach build
``

で良いらしい

ちなみにとんでもない時間がかかる。公式ビルドが PGO をしている && march
とか付けてもセグるバージョンが多いので、自分で build しないのも一手。

# Firefox の LTO ビルド

まずバグがある。

https://bugzilla.mozilla.org/show_bug.cgi?id=1258215

ただし、相当の メモリを使うようだ。メモリ 7GB + Swap 10GB でもエラーとなる。なのであきらめ
た。

# -march 使うと

ビルドに成功しても、セグる。-mtune だと OK だったりする。

60.0.1 は -march で OK
62.0.2 は -march, -mtune ともに NG. ただし PGO も有効にしていたので、そのせいかどうかは不
明。-O2 のみなら成功

## gdb で coredump を読んでみた

62.0.2 のとき ``coredumpctl list`` で journal に保存されている coredump を探し、 ``coredumpctl gdb 11146`` とういうように PID で gdb を開始。

``
(gdb)bt
---- 省略 ---
#61 0x00007fa909048b38 in XRE_main (argc=4, argv=0x7ffc4e14b608, aConfig=...)
    at /sources/firefox-62.0.2/toolkit/xre/nsAppRunner.cpp:4984
#62 0x0000000000422648 in do_main (argc=4, argv=0x7ffc4e14b608, envp=<optimized out>)
    at /sources/firefox-62.0.2/browser/app/nsBrowserApp.cpp:233
#63 0x000000000041544a in main (argc=4, argv=0x7ffc4e14b608, envp=0x7ffc4e14b630)
    at /sources/firefox-62.0.2/browser/app/nsBrowserApp.cpp:311
``

という感じになるので、最後の 63 を調べてみる

``
(gdb) f 63
#63 0x000000000041544a in main (argc=4, argv=0x7ffc4e14b608, envp=0x7ffc4e14b630)
    at /sources/firefox-62.0.2/browser/app/nsBrowserApp.cpp:311
311       int result = do_main(argc, argv, envp);
(gdb) p result
$6 = <optimized out>
(gdb) p argc
$7 = 4
(gdb) p argv
$8 = (char **) 0x7ffc4e14b608
(gdb) p envp
$9 = (char **) 0x7ffc4e14b630
``

となり、result が最適化されて取り除かれているということらしい。

<!-- vim: set tw=90 filetype=markdown : -->
