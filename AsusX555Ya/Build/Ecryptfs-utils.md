# Ecryptfs-Utils-111

どういう分けか nss を見つけて適切な -I や -l を設定してくれない

```
export CPPFLAGS='-I/usr/include/nss -I/usr/include/nspr'
export LDFLAGS="-L/usr/lib"         
export LIBS='-lnss3'
```

これはただの本体へ対話機能なので pgo は不要でしょう。

Arch の openssl に関する patch が必要

```
cat > ssl.patch <<EOF
=== modified file 'src/key_mod/ecryptfs_key_mod_openssl.c'
--- src/key_mod/ecryptfs_key_mod_openssl.c  2013-10-25 19:45:09 +0000
+++ src/key_mod/ecryptfs_key_mod_openssl.c  2017-03-13 20:34:27 +0000
@@ -50,6 +50,20 @@
 #include "../include/ecryptfs.h"
 #include "../include/decision_graph.h"
 
+#if OPENSSL_VERSION_NUMBER < 0x10100000L
+void RSA_get0_key(const RSA *r,
+                 const BIGNUM **n, const BIGNUM **e, const BIGNUM **d)
+{
+   if (n != NULL)
+       *n = r->n;
+   if (e != NULL)
+       *e = r->e;
+   if (d != NULL)
+       *d = r->d;
+}
+#endif
+
+
 struct openssl_data {
  char *path;
  char *passphrase;
@@ -142,6 +156,7 @@
 {
  int len, nbits, ebits, i;
  int nbytes, ebytes;
+ const BIGNUM *key_n, *key_e;
  unsigned char *hash;
  unsigned char *data = NULL;
  int rc = 0;
@@ -152,11 +167,13 @@
    rc = -ENOMEM;
    goto out;
  }
- nbits = BN_num_bits(key->n);
+ RSA_get0_key(key, &key_n, NULL, NULL);
+ nbits = BN_num_bits(key_n);
  nbytes = nbits / 8;
  if (nbits % 8)
    nbytes++;
- ebits = BN_num_bits(key->e);
+ RSA_get0_key(key, NULL, &key_e, NULL);
+ ebits = BN_num_bits(key_e);
  ebytes = ebits / 8;
  if (ebits % 8)
    ebytes++;
@@ -179,11 +196,13 @@
  data[i++] = '\02';
  data[i++] = (nbits >> 8);
  data[i++] = nbits;
- BN_bn2bin(key->n, &(data[i]));
+ RSA_get0_key(key, &key_n, NULL, NULL);
+ BN_bn2bin(key_n, &(data[i]));
  i += nbytes;
  data[i++] = (ebits >> 8);
  data[i++] = ebits;
- BN_bn2bin(key->e, &(data[i]));
+ RSA_get0_key(key, NULL, &key_e, NULL);
+ BN_bn2bin(key_e, &(data[i]));
  i += ebytes;
  SHA1(data, len + 3, hash);
  to_hex(sig, (char *)hash, ECRYPTFS_SIG_SIZE);
@@ -278,7 +297,9 @@
  BIO *in = NULL;
  int rc;
 
+ #if OPENSSL_VERSION_NUMBER < 0x10100000L
  CRYPTO_malloc_init();
+ #endif
  ERR_load_crypto_strings();
  OpenSSL_add_all_algorithms();
  ENGINE_load_builtin_engines();
EOF

patch -Np0 -i ssl.patch
```

```
./configure --prefix=/usr
```


<!-- vim: set tw=90 filetype=markdown : -->
