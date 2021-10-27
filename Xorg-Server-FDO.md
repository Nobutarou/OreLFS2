# xorg-server の FDO ビルド

まず、FDO 云々に関わらず、

``
--disable-systemd-logind --enable-install-setuid
``

は必要。

それから /opt に prefix を設定してしまうと、xkb の設定ファイルとかまでがそっちにあると思い
込んでて起動しない。リンクを貼るのも良いけど、/usr から /opt に張るのは何か気持が悪いので
やめとく。また xkbhogehoge を再ビルドするにしても xorg-server と prefix を揃えなくてはなら
ないので、何のための /opt か分からなくなる。xorg.conf でも設定できんなかも知れないけど、良
く分からない。

ということで、素直に

``
--prefix=/usr
``

にしておく。

あとは特にビルドで問題は出ない。

# ドライバーにエラーが出るかも

どうもパフォーマンスが落ちたので Xorg.0.log を見たら

``
(EE) amdgpu: module ABI major version (23) doesn't match the server's version (24)
``

と出ていた。新しいバージョンの AMDGPU をビルドしたら消えた。

# Clang で PGO は

``-fprofile-use`` 付きだと ./configure の conftest.c のところでこける。仕方ないので ``-O2 -march=native`` で ./configure 通しておいてから


```
foreach i in $( grep -rl "\-O2 \-march\=native" ./ )
do
sed -i 's/-O2 -march=native/-O2 -fprofile-use=\/sources\/gcda\/xorg-server-1.20.4 -march=native/' $i
done
```

で無理矢理 PGO 実行した。

# 1.20.4 で clang ビルドエラー

```
xtest.c:64:23: error: suggest braces around initialization of subobject [-Werror,-Wmissing-braces]
    WindowRec root = {0};
```

ググったら、

```
diff --git a/test/xtest.c b/test/xtest.c
index fc5e433..d7e6620 100644
--- a/test/xtest.c
+++ b/test/xtest.c
@@ -61,7 +61,7 @@ xtest_init_devices(void)
 {
     ScreenRec screen = {0};
     ClientRec server_client = {0};
-    WindowRec root = {0};
+    WindowRec root = {{0}};
     WindowOptRec optional = {0};
```

というのが出てきた。{} を一つ足すだけで良いようだ。

<!-- vim: set tw=90 filetype=markdown : -->
