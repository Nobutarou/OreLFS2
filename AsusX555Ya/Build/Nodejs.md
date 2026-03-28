# 12.16.3

clang で pgo 初回が通った。二回目は lto をしなければ通った。

# Node.js-12.16.1

```
  clang++ -o /sources/node-v12.16.1/out/Release/obj.target/libnode/src/api/hooks.o ../src/api/hooks.cc '-DV8_DEPRECATION_WARNINGS' '-DV8_IMMINENT_DEPRECATION_WARNINGS' '-D__STDC_FORMAT_MACROS' '-DNODE_ARCH="x64"' '-DNODE_PLATFORM="linux"' '-DNODE_WANT_INTERNALS=1' '-DV8_DEPRECATION_WARNINGS=1' '-DNODE_OPENSSL_SYSTEM_CERT_PATH=""' '-DHAVE_INSPECTOR=1' '-DNODE_REPORT' '-D__POSIX__' '-DNODE_USE_V8_PLATFORM=1' '-DNODE_HAVE_I18N_SUPPORT=1' '-DHAVE_OPENSSL=1' '-DHTTP_PARSER_STRICT=0' '-DNGHTTP2_STATICLIB' -I../src -I/sources/node-v12.16.1/out/Release/obj/gen -I/sources/node-v12.16.1/out/Release/obj/gen/include -I/sources/node-v12.16.1/out/Release/obj/gen/src -I../deps/histogram/src -I../deps/uvwasi/include -I../deps/v8/include -I../deps/http_parser -I../deps/llhttp/include -I../deps/cares/include -I../deps/nghttp2/lib/includes -I../deps/brotli/c/include  -Wall -Wextra -Wno-unused-parameter -pthread -Wall -Wextra -Wno-unused-parameter -m64 -O3 -fno-omit-frame-pointer -fno-rtti -fno-exceptions -std=gnu++1y -MMD -MF /sources/node-v12.16.1/out/Release/.deps//sources/node-v12.16.1/out/Release/obj.target/libnode/src/api/hooks.o.d.raw  -O2 -fprofile-generate=/sources/gcda/node-v12.16.1  -c
../src/api/environment.cc:187:39: error: use of undeclared identifier 'uv_get_constrained_memory'; did you mean 'uv_get_total_memory'?
  const uint64_t constrained_memory = uv_get_constrained_memory();
                                      ^~~~~~~~~~~~~~~~~~~~~~~~~
                                      uv_get_total_memory
/usr/include/uv.h:1531:20: note: 'uv_get_total_memory' declared here
UV_EXTERN uint64_t uv_get_total_memory(void);
                   ^
```

gcc での pgo は私は無理。

```
  g++ -o /sources/node-v12.16.1/out/Release/bytecode_builtins_list_generator -pthread -rdynamic -m64 -m64 -lgcov -Wl,--start-group /sources/node-v12.16.1/out/Release/obj.target/bytecode_builtins_list_generator/deps/v8/src/builtins/generate-bytecodes-builtins-list.o /sources/node-v12.16.1/out/Release/obj.target/bytecode_builtins_list_generator/deps/v8/src/interpreter/bytecode-operands.o /sources/node-v12.16.1/out/Release/obj.target/bytecode_builtins_list_generator/deps/v8/src/interpreter/bytecodes.o /sources/node-v12.16.1/out/Release/obj.target/tools/v8_gypfiles/libv8_libbase.a -lz -luv -lcrypto -lssl -licui18n -licuuc -licudata -ldl -lrt -Wl,--end-group
/sources/node-v12.16.1/out/Release/obj.target/gen-regexp-special-case/deps/v8/src/regexp/gen-regexp-special-case.o: 関数 `_GLOBAL__sub_I__ZN2v88internal8PrintSetERSt14basic_ofstreamIcSt11char_traitsIcEEPKcRKN6icu_6510UnicodeSetE' 内:
gen-regexp-special-case.cc:(.text._GLOBAL__sub_I__ZN2v88internal8PrintSetERSt14basic_ofstreamIcSt11char_traitsIcEEPKcRKN6icu_6510UnicodeSetE+0xa3): `__gcov_time_profiler_counter' に対する定義されてい
ない参照です
g
```


# Nodejs は適当な cflags で十分

firefox の ビルドにのみ使われるようだ。clang で profile を作らせようとしていたが、どんなに
firefox を使っていてもプロファイルができないところからの判断。


<!-- vim: set tw=90 filetype=markdown : -->
