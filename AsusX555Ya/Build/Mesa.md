# --prefix の件

Mesa は --prefix=/usr にしとくべき

xf86-video-ati-7.9.0 が $prefix/lib/dri/ のライブラリを見に行ってしまう。LD_LIBRARY_PATH
も効かないし、xorg.conf の ModulePath も効かない。やるなら DESTDIR

``
./configure  --prefix=/usr --sysconfdir=/etc \
            --enable-texture-float             \
            --enable-osmesa                    \
            --enable-xa                        \
            --enable-glx-tls                   \
            --with-platforms="drm,x11,wayland" \
 --with-gallium-drivers='radeonsi' \
 --with-vulkan-drivers=radeon \
 --enable-opencl  --enable-opencl-icd
``

# PGO の件

何とか missmatch でエラー。

       -Wno-coverage-mismatch
           Warn if feedback profiles do not match when using the -fprofile-use option.  If a source
           file is changed between compiling with -fprofile-gen and with -fprofile-use, the files
           with the profile feedback can fail to match the source file and GCC cannot use the
           profile feedback information.  By default, this warning is enabled and is treated as an
           error.  -Wno-coverage-mismatch can be used to disable the warning or
           -Wno-error=coverage-mismatch can be used to disable the error.  Disabling the error for
           this warning can result in poorly optimized code and is useful only in the case of very
           minor changes such as bug fixes to an existing code-base.  Completely disabling the
           warning is not recommended.

configure オプションが一致していない場合に発生。configure をテキストファイルに保存しておい
て使い回すのが吉。

# GLL_DRV

I don't know what I need. To check it, I test
``sh
GLL_DRV="radeonsi,svga,swrast"
``
<!-- vim: set tw=90 filetype=markdown : -->
