# 2020.12.09

The easiest way to build Chromium is using Ubuntu. However, the build command doesn't take
CFALGS into account. Thus, there is no benefit to compile it by myself.

Use Google Chrome instead!

# 2020.05.20 

never touch Chromium again.

```
> autoninja -j4 -v -C out/mybuild chrome
ninja: Entering directory `out/mybuild'
[1/313] python "../../build/toolchain/gcc_solink_wrapper.py" --readelf="readelf" --nm="nm" --sofile="./libblink_modules.so" --tocfile="./libblink_modules.so.TOC" --output="./libblink_modules.so" -- ../../third_party/llvm-build/Release+Asserts/bin/clang++ -shared -Wl,-soname="libblink_modules.so" -Wl,--fatal-warnings -fPIC -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,defs -Wl,--as-needed -fuse-ld=lld -Wl,--icf=all -Wl,--color-diagnostics -m64 -Werror -Wl,-O2 -Wl,--gc-sections -rdynamic -nostdlib++ --sysroot=../../build/linux/debian_sid_amd64-sysroot -L../../build/linux/debian_sid_amd64-sysroot/usr/local/lib/x86_64-linux-gnu -L../../build/linux/debian_sid_amd64-sysroot/lib/x86_64-linux-gnu -L../../build/linux/debian_sid_amd64-sysroot/usr/lib/x86_64-linux-gnu -Wl,-rpath=\$ORIGIN -o "./libblink_modules.so" @"./libblink_modules.so.rsp"
FAILED: libblink_modules.so libblink_modules.so.TOC
python "../../build/toolchain/gcc_solink_wrapper.py" --readelf="readelf" --nm="nm" --sofile="./libblink_modules.so" --tocfile="./libblink_modules.so.TOC" --output="./libblink_modules.so" -- ../../third_party/llvm-build/Release+Asserts/bin/clang++ -shared -Wl,-soname="libblink_modules.so" -Wl,--fatal-warnings -fPIC -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,defs -Wl,--as-needed -fuse-ld=lld -Wl,--icf=all -Wl,--color-diagnostics -m64 -Werror -Wl,-O2 -Wl,--gc-sections -rdynamic -nostdlib++ --sysroot=../../build/linux/debian_sid_amd64-sysroot -L../../build/linux/debian_sid_amd64-sysroot/usr/local/lib/x86_64-linux-gnu -L../../build/linux/debian_sid_amd64-sysroot/lib/x86_64-linux-gnu -L../../build/linux/debian_sid_amd64-sysroot/usr/lib/x86_64-linux-gnu -Wl,-rpath=\$ORIGIN -o "./libblink_modules.so" @"./libblink_modules.so.rsp"
ld.lld: error: undefined symbol: blink::LaunchQueue::wrapper_type_info_
>>> referenced by launch_queue.cc
>>>               obj/third_party/blink/renderer/modules/launch/launch/launch_queue.o:(blink::LaunchQueue::GetWrapperTypeInfo() const)

ld.lld: error: undefined symbol: blink::LockManager::wrapper_type_info_
>>> referenced by lock_manager.cc
>>>               obj/third_party/blink/renderer/modules/locks/locks/lock_manager.o:(blink::LockManager::GetWrapperTypeInfo() const)

ld.lld: error: undefined symbol: blink::v8_lock_manager_wrapper_type_info
>>> referenced by v8_service_worker_global_scope.cc
>>>               obj/third_party/blink/renderer/bindings/modules/v8/bindings_modules_impl/v8_service_worker_global_scope.o:(blink::V8ServiceWorkerGlobalScope::LockManagerConstructorGetterCallback(v8::Local<v8::Name>, v8::PropertyCallbackInfo<v8::Value> const&))

ld.lld: error: undefined symbol: blink::v8_launch_queue_wrapper_type_info
>>> referenced by v8_window_partial.cc
>>>               obj/third_party/blink/renderer/bindings/modules/v8/bindings_modules_impl/v8_window_partial.o:(blink::V8WindowPartial::LaunchQueueConstructorGetterCallback(v8::Local<v8::Name>, v8::PropertyCallbackInfo<v8::Value> const&))
clang: error: linker command failed with exit code 1 (use -v to see invocation)
ninja: build stopped: subcommand failed.
````

After 20 hours waiting, it failed. Spending 21GB, but failed. Using pre-build is better,
but using Chrome is better than it.


<!-- vim: set tw=90 filetype=markdown : -->
