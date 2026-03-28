# Mojoshader を Clang で PGO

まず、いろいろコピーされてたりフォークされてたりするが、本家に従い、

```
hg clone https://hg.icculus.org/icculus/mojoshader/ 
```

```
ccmake ..
```

して (cmake 使いこなせないので),

```
 BUILD_SHARED                     ON
 COMPILER_SUPPORT                 ON
 DEPTH_CLIPPING                   ON
 EFFECT_SUPPORT                   ON
 FLIP_VIEWPORT                    ON
 PROFILE_ARB1                     ON
 PROFILE_ARB1_NV                  ON
 PROFILE_BYTECODE                 ON
 PROFILE_D3D                      ON
 PROFILE_GLSL                     ON
 PROFILE_GLSL120                  ON
 PROFILE_METAL                    ON 
 XNA4_VERTEXTEXTURE               ON
 CMAKE_CXX_FLAGS_RELEASE          -O2 -DNDEBUG
 CMAKE_C_FLAGS_RELEASE            -O2 -DNDEBUG
```

上記のフィーチャーはデフォルトだといくつか off になっているが、それだと Terraria
の配布と入れかえても動かない。


<!-- vim: set tw=90 filetype=markdown : -->
