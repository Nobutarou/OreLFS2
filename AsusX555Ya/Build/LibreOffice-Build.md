# LibreOffice-5.3.0 

## FDO 挑戦
FDO できるか分からないけど、とりあえず下のようにしてみたんだけど、ほとんど external と言っ
て弾かれる。まこれは無理なんだろうな。別途ダウンロードするものが多すぎる。

``
./autogen.sh --prefix=/opt/libreoffice-5.3.0.3-PreFDO        \
             --with-vendor=BLFS          \
             --with-lang='ja en-GB'      \
             --with-myspell-dicts        \
             --with-alloc=system         \
             --without-junit             \
             --without-system-dicts      \
             --disable-dconf             \
             --disable-odk               \
             --disable-firebird-sdbc     \
             --enable-release-build=yes  \
             --enable-python=system      \
             --with-system-apr           \
             --with-system-boost         \
             --with-system-cairo         \
             --with-system-clucene       \
             --with-system-curl          \
             --with-system-expat         \
             --with-system-graphite      \
             --with-system-harfbuzz      \
             --with-system-icu           \
             --with-system-jpeg          \
             --with-system-lcms2         \
             --with-system-libatomic_ops \
             --with-system-libpng        \
             --with-system-libxml        \
             --with-system-neon          \
             --with-system-nss           \
             --with-system-odbc          \
             --with-system-openldap      \
             --with-system-openssl       \
             --with-system-poppler       \
             --with-system-postgresql    \
             --with-system-redland       \
             --with-system-serf          \
             --with-system-zlib \
             --with-system-libabw \
             --disable-breakpad \
             --disable-scripting-beanshell \
             --with-system-bzip2 \
             --with-system-libcdr \
             --with-system-libcmis \
             --disable-coinmp \
             --disable-collada \
             --disable-ext-ct2n \
             --without-help \
             --with-system-libebook \
             --disable-epm \
             --with-system-libetonyek \
             --without-fonts \
             --with-system-libfreehand \
             --with-system-glew \
             --with-system-glm \
             --with-system-hunspell --disable-liblangtag --with-system-libeot \
 --with-system-libexttextcat  --disable-gltf  --with-system-libtommath \
 --disable-lpsolve --with-system-mdds --with-system-libmspub --with-system-libmwaw \
 --with-system-mythes --disable-neon --with-system-libodfgen --without-export-validation\
 --with-system-libpagemaker --with-system-librevenge --with-webdav=no \
 --with-system-libstaroffice --with-system-ucpp --with-system-libvisio \
 --with-system-libwpd --with-system-libwpg --with-system-libwps \
 --with-system-libzmf 
``

## LTO は？

configure に --enable-lto がある。CFLAGS からは外してやってみる。

### Webdav エラー

まず幸先よく Webdav でエラー。要らんのだけどなぁ。
``
/sources/libreoffice-5.3.0.3/ucb/source/ucp/webdav/webdavcontent.cxx:2031:60: エラー: use of deleted function ‘void com::sun::star::uno::operator<<=(com::sun::star::uno::Any&, const C&) [with C = com::sun::star::uno::Any]’
``

とりあえず、-with-webdav を削除してみる

### libexttextcat でエラー

あ、graft し忘れてた。っていうか pkg-config あるんだから使ってほしい。

``
/sources/libreoffice-5.3.0.3/lingucomponent/source/languageguessing/guess.cxx:24:10: 致命的エラー: ltextcat/textcat.h: そのようなファイルやディレクトリはありません
 #include <libexttextcat/textcat.h>
``

### また webdav エラー

ほんと要らんのに、、、 --disable-neon も外す。
``
/sources/libreoffice-5.3.0.3/ucb/source/ucp/webdav/webdavcontent.cxx:2031:60: エラー: use of deleted function ‘void com::sun::star::uno::operator<<=(com::sun::star::uno::Any&, const C&) [with C = com::sun::star::uno::Any]’
``

### FDO 関連でエラー

おっと、Glu は LTO でビルドするか。ところでどうもこれは check でのエラーらしい。

``
Failures !!!
Run: 38   Failure total: 1   Failures: 1   Errors: 0
profiling:/source:Cannot create directory
profiling:/source/fdo/glu-9.0.0/src/libnurbs/nurbtess/.libs/searchTree.gcda:Skip
profiling:/source:Cannot create directory
profiling:/source/fdo/glu-9.0.0/src/libnurbs/nurbtess/.libs/sampledLine.gcda:Skip
``

``
make build-noceck
``

で行けた。

<!-- vim: set tw=90 filetype=markdown : -->
