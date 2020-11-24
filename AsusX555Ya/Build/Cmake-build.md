# FDO ビルドは無理
``
/opt/gcc-7/bin/g++ -march=native -O2 -ftree-vectorize -fprofile-use -fprofile-correction
-pipe      -I/sources/cmake-3.10.2/Bootstrap.cmk   -I/sources/cmake-3.10.2/Source
-I/sources/cmake-3.10.2/Source/LexerParser   -I/sources/cmake-3.10.2/Utilities
-DKWSYS_NAMESPACE=cmsys -DKWSYS_CXX_HAS_SETENV=0 -DKWSYS_CXX_HAS_UNSETENV=0
-DKWSYS_CXX_HAS_ENVIRON_IN_STDLIB_H=0 -DKWSYS_CXX_HAS_UTIMENSAT=0 -DKWSYS_CXX_HAS_UTIMES=0
-c /sources/cmake-3.10.2/Source/kwsys/SystemTools.cxx -o SystemTools.o
/sources/cmake-3.10.2/Source/kwsys/SystemTools.cxx: 関数 ‘void
__static_initialization_and_destruction_0(int, int)’ 内:
/sources/cmake-3.10.2/Source/kwsys/SystemTools.cxx:4707:1: エラー: the control flow of
function ‘_Z41__static_initialization_and_destruction_0ii’ does not match its profile
data (counter ‘arcs’) [-Werror=coverage-mismatch]
``

bootstrap があるからおかしくなるんだろう。やめよう

# LTO は
``
/usr/bin/ar: CMakeFiles/cmlibrhash.dir/librhash/algorithms.c.o: plugin needed to handle
lto object
``
系のがいろいろ出てくる。AR=gcc-ar にしてても、/usr/bin/ar を見に行くのをやめない。
よく分からないから諦める。

<!- vim: set tw=90 filetype=markdown : -->
