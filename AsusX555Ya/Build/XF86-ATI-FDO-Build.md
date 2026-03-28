# xf86-video-ati-7.9.0 の FDO ビルド

## コンパイル初回

``zsh
export CFLAGS="-march=native -O2 -fprofile-generate -fprofile-arcs "
export CXXFLAGS=$CFLAGS
export LDFLAGS='-lgcov'
``

``zsh
./configure --prefix=/opt/xf86-video-ati-7.9.0-PreFDO
``

で。あと、/etc/X11/xorg.conf をいじって今回のドライバーを先に見つけさせる。

``
Section "Files"
	ModulePath   "/opt/xf86-video-ati-7.9.0-PreFDO/lib/xorg/modules"
	ModulePath   "/usr/lib/xorg/modules"
......
``

なぜか X の再起動では gcda ファイルができなかったのでシステムを再起動したら出きた。

## 二回目

説明省略

``
cd /opt
ln -sv xf86-video-ati-7.9.0-FDO xf86-video-ati-7
``

として

/etc/X11/xorg.conf
``
Section "Files"
	ModulePath   "/opt/xf86-video-ati-7/lib/xorg/modules"
	ModulePath   "/usr/lib/xorg/modules"
......
``

としておいた。

<!-- vim: set tw=90 filetype=markdown : -->
