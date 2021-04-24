# FFmpeg

# 4.2.2

CC=clang が効かない。configure で --cc と --cxx の明示が必要. --enable-lto
もある. 勝手に -O3 も入るが --optflags で上書きできる。

```
% ./configure --prefix=/usr        \              
            --enable-gpl         \
            --enable-version3    \
            --enable-nonfree     \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-avresample  \
            --enable-libass      \
            --enable-libfdk-aac  \
            --enable-libfreetype \
            --enable-libmp3lame  \
            --enable-libopus     \
            --enable-libtheora   \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-libx265     \
            --docdir=/usr/share/doc/ffmpeg-4.2.2 \
          --cc=clang --cxx=clang++ --enable-lto --optflags="-O2"
```


<!-- vim: set tw=90 filetype=markdown : -->
