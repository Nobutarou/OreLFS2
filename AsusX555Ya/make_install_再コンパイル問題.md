# sudo make install で コンパイルがもう一度走る問題

Makefile の書きかたか、関連スクリプトのせいか知らないけど、sudo make install すると、せっ
かくユーザー権限で make してあるにもかかわらず、もう一度コンパイルしだすことがある。

- もし、CFLAGS とかが ユーザーと root で違うせいなら同じにしておきたい
- もし、再コンパイルをどうしてもしてしまうとしても、同じ条件のコンパイルにしたい

ということで、PATH, CFLAGS, CXXFLAGS は /etc/zsh/zshrc で共通化、ccache も /etc/ccache で
共通化する。

<!-- vim: set tw=90 filetype=markdown : -->
