# 10.0.0

https://releases.llvm.org/10.0.0/docs/HowToBuildWithPGO.html

の通りにやってみる。lld を tools に展開する必要がある。しかし
> {{{
```
[1101/1103] Linking CXX executable unittests/tools/llvm-exegesis/X86/LLVMExegesisX86Tests
FAILED: tools/clang/test/CMakeFiles/check-clang
cd /sources/llvm-10.0.0.src/out/instrumented/tools/clang/test && /usr/bin/python3.8 /sources/llvm-10.0.0.src/out/instrumented/./bin/llvm-lit -sv --param clang_site_config=/sources/llvm-10.0.0.src/out/instrumented/tools/clang/test/lit.site.cfg --param USE_Z3_SOLVER=0 /sources/llvm-10.0.0.src/out/instrumented/tools/clang/test
ninja: build stopped: subcommand failed.
*** Building instrumented clang...
*** Running profdata benchmarks...
Running `cmake -G Ninja /sources/llvm-10.0.0.src -DCLANG_TABLEGEN=/sources/llvm-10.0.0.src/out/stage1/bin/clang-tblgen -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=/sources/llvm-10.0.0.src/out/stage1/bin/clang++ -DCMAKE_C_COMPILER=/sources/llvm-10.0.0.src/out/stage1/bin/clang -DCMAKE_INSTALL_PREFIX=/usr -DLLVM_BINUTILS_INCDIR=/usr/include/ -DLLVM_BUILD_INSTRUMENTED=IR -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_BUILD_RUNTIME=No -DLLVM_BUILD_TESTS=ON -DLLVM_ENABLE_FFI=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_TABLEGEN=/sources/llvm-10.0.0.src/out/stage1/bin/llvm-tblgen '-DLLVM_TARGETS_TO_BUILD=host;AMDGPU;BPF'` in /sources/llvm-10.0.0.src/out/instrumented
Running `ninja clang lld` in /sources/llvm-10.0.0.src/out/instrumented
Running `ninja check-llvm check-clang` in /sources/llvm-10.0.0.src/out/instrumented
Traceback (most recent call last):
  File "../utils/collect_and_build_with_pgo.py", line 480, in <module>
    _main()
  File "../utils/collect_and_build_with_pgo.py", line 466, in _main
    _run_benchmark(env, instrumented_out, args.include_debug_info)
  File "../utils/collect_and_build_with_pgo.py", line 44, in _run_benchmark
    _build_things_in(env, out_dir, what=['check-llvm', 'check-clang'])
  File "../utils/collect_and_build_with_pgo.py", line 233, in _build_things_in
    env.run_command(cmd, cwd=target_dir, check=True)
  File "../utils/collect_and_build_with_pgo.py", line 194, in run_command
    raise subprocess.CalledProcessError(
subprocess.CalledProcessError: Command '['ninja', 'check-llvm', 'check-clang']' returned non-zero exit status 1.
```

分からない。 .py を直接編集して check-llvm と check-clang を止めてみる

あ、http://llvm.org/docs/TestingGuide.html 読むと check-clang というのは見あたらず
check-all すると良さそうだが。が、放置しておいたらシャットダウンされていた。jounalctl にも
シャットダウンが出てない。分からない。これまで通り、自力 PGO にしよう。

ただし、gcc でビルドするときに -lgcov 付けていると、clang で何かしようとするときに

```
/usr/bin/ld:
/opt/llvm-10.0.0.src_gspre/usr/lib/clang/10.0.0/lib/linux/libclang_rt.profile-x86_64.a(InstrProfilingValue.c.o):
in function `allocateValueProfileCounters':
InstrProfilingValue.c:(.text.allocateValueProfileCounters+0x11): undefined reference to
`__gcov_time_profiler_counter'
/usr/bin/ld:
/opt/llvm-10.0.0.src_gspre/usr/lib/clang/10.0.0/lib/linux/libclang_rt.profile-x86_64.a(InstrProfilingValue.c.o):
in function `allocateOneNode':
InstrProfilingValue.c:(.text.allocateOneNode+0x11): undefined reference to
`__gcov_time_profiler_counter'
/
```

のようなエラーが大量に出る。対処できないので、gcc でビルドする一回目は何もしないのが無難だ
。

残念なことに clang で ビルドしてもこんなんなる。 
```
/usr/bin/ld: projects/compiler-rt/lib/sanitizer_common/CMakeFiles/RTSanitizerCommon.x86_64.dir/sanitizer_allocator.cpp.o:(.data.DW.ref.__gxx_personality_v0[DW.ref.__gxx_personality_v0]+0x0): undefined reference to `__gxx_personality_v0'
```

compiler-rt は archpkg だと、独立してビルドしてるので、まずは compiler-rt をビルドしてみる。-fPIC が必要だとかなんだとか。で check-llvm, check-clang しようにも

```
LLVM Profile Error: Failed to write file
"/sources/gcda/llvm-10.0.0.src/default_6384237444331238501_0.profraw": File exists
LLVM Profile Warning: Unable to merge profile data: source profile file is not compatible.
```
> }}}
が大量に出る。check で集めるのではなく 通常作業で集めるか。いや、いろいろだめだ。以下のこ
れまで通りのやりかたが良いだろう。

一応 普通のブート環境で,オプションいっさい付けずにやってみたが、途中でシャットダウンしてし
まう。

# PGO まとめ

とりあえず LLVM ライブラリのみ PGO をる

まず BLFS 通り、LLVM, Compiler-RT, Clang を普通にビルドする。

次に、LLVM のみで

```
CC=clang
CXX=clang++
CFLAGS=-O2 -fprofile-generate=/sources/gcda/llvm-9.0.1.src
CXXFLAGS=-O2 -fprofile-generate=/sources/gcda/llvm-9.0.1.src
LDFLAGS=-fprofile-generate=/sources/gcda/llvm-9.0.1.src
LIBS=
QMAKE_CFLAGS=-O2 -fprofile-generate=/sources/gcda/llvm-9.0.1.src
QMAKE_CXXFLAGS=-O2 -fprofile-generate=/sources/gcda/llvm-9.0.1.src
QMAKE_LDFLAGS=-fprofile-generate=/sources/gcda/llvm-9.0.1.src
QMAKE_LIBS=-fprofile-generate=/sources/gcda/llvm-9.0.1.src
QMAKE_LINKER=clang++
QMAKE_CC=clang
QMAKE_CXX=clang++
```

としておいて

```
cmake -DCMAKE_INSTALL_PREFIX=/usr               \
      -DLLVM_ENABLE_FFI=ON                      \
      -DCMAKE_BUILD_TYPE=Release                \
      -DLLVM_BUILD_LLVM_DYLIB=ON                \
      -DLLVM_LINK_LLVM_DYLIB=ON                 \
      -DLLVM_ENABLE_RTTI=ON                     \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
      -DLLVM_BUILD_TESTS=ON                     \
      -DLLVM_BINUTILS_INCDIR=/usr/include/ \
  -Wno-dev -G Ninja ..
```

でビルド。 <install dir>/usr/lib の .so .a のみ /usr/lib/ に上書き。

適当に プロファイル集めたら二度目のビルド. 

```
CC=clang
CXX=clang++
CFLAGS=-O2 -fprofile-use=/sources/gcda/llvm-9.0.1.src -flto -march=native
CXXFLAGS=-O2 -fprofile-use=/sources/gcda/llvm-9.0.1.src -flto -march=native
LDFLAGS=-flto -fprofile-use=/sources/gcda/llvm-9.0.1.src
LIBS=
QMAKE_CFLAGS=-O2 -fprofile-use=/sources/gcda/llvm-9.0.1.src -flto -march=native
QMAKE_CXXFLAGS=-O2 -fprofile-use=/sources/gcda/llvm-9.0.1.src -flto -march=native
QMAKE_LDFLAGS=-flto -fprofile-use=/sources/gcda/llvm-9.0.1.src
QMAKE_LIBS=
```






# libLLVM.so だけ PGO 出来ないのかな?

コンパイラの速さじゃなくて、libLLVM.so を最適化したいんだから、

clang や compiler-rt を展開せずに

```
CC=clang
CXX=clang++
CFLAGS=-O2 -fprofile-generate=/sources/gcda/llvm-7.0.1.src
CXXFLAGS=-O2 -fprofile-generate=/sources/gcda/llvm-7.0.1.src
LDFLAGS=-fprofile-generate=/sources/gcda/llvm-7.0.1.src
LIBS=
```

```sh
cmake -DCMAKE_INSTALL_PREFIX=/usr               \
      -DLLVM_ENABLE_FFI=ON                      \
      -DCMAKE_BUILD_TYPE=Release                \
      -DLLVM_BUILD_LLVM_DYLIB=ON                \
      -DLLVM_LINK_LLVM_DYLIB=ON                 \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
      -DLLVM_BUILD_TESTS=ON                     \
    -DLLVM_BINUTILS_INCDIR=/usr/include/ \
      -Wno-dev -G Ninja ..
```

``ccmake ..`` で補正

```
 CMAKE_ASM_FLAGS_RELEASE          -O2 -DNDEBUG
 CMAKE_CXX_FLAGS_RELEASE          -O2 -DNDEBUG
 CMAKE_C_FLAGS_RELEASE            -O2 -DNDEBUG
```

で /usr/lib/{libLLVM.so,libLLVM-7.0.0.so,libLLVM-7.so} を入れ替えて、ターゲットのアプリを実行

次にこれで同じことをやれば完成

```
CC=clang
CXX=clang++
CFLAGS=-O2 -fprofile-use=/sources/gcda/llvm-7.0.0.src -march=native
CXXFLAGS=-O2 -fprofile-use=/sources/gcda/llvm-7.0.0.src -march=native
LDFLAGS=-fprofile-use=/sources/gcda/llvm-7.0.0.src
LIBS=
```

もしかして libstdc++.so も同じようにあとから PGO できる？？？


<!-- vim: set tw=90 filetype=markdown : -->
