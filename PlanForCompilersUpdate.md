# GCC, LLVM, How I can safely update them?

I used DESTDIR and symlink method by graft. I mean I uninstalled an old version and
installed a newer version. However, I met some binarys broken and Xorg
server didn't run when I updated to GCC-11.2.0 and LLVM-13.0.0.

Thus, for future updates, I will change PREFIX to install and modify /etc/ld.so.conf and
PKG_CONFIG_PATH and PATH. This will be safer. 

<!-- vim: set tw=90 filetype=markdown : -->

