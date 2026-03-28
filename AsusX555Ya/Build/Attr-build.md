# Attr-2.4.48

``make check`` でこけるので次のパッチ

```
--- test/run.old	2018-11-19 19:55:45.650272789 +0900
+++ test/run	2018-11-19 19:57:03.020272581 +0900
@@ -106,7 +106,7 @@
   if (defined $line) {
     # Substitute %VAR and %{VAR} with environment variables.
     $line =~ s[%(\w+)][$ENV{$1}]eg;
-    $line =~ s[%{(\w+)}][$ENV{$1}]eg;
+    $line =~ s[%\{(\w+)}][$ENV{$1}]eg;
   }
   if (defined $line) {
     if ($line =~ s/^\s*< ?//) {
```

また ``LANG=C make check`` しないとこける


<!-- vim: set tw=90 filetype=markdown : -->
