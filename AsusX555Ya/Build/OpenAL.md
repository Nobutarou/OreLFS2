# OpenAl-1.19.1

```
cmake -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_LIBDIR=lib \
 -DALSOFT_EXAMPLES=OFF \
 -DCMAKE_CXX_FLAGS_RELEASE='-O2 -DNDEBUG' \
 -DCMAKE_C_FLAGS_RELEASE='-O2 -DNDEBUG' ..
``` 

example を off にしないと ld が -lex-common を見つけられないというエラーが出る。


<!-- vim: set tw=90 filetype=markdown : -->
