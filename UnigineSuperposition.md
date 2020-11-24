# QT SSL 関連のエラーがたくさん出てくる

```
qt.network.ssl: QSslSocket: cannot resolve CRYPTO_num_locks
qt.network.ssl: QSslSocket: cannot resolve CRYPTO_set_id_callback
qt.network.ssl: QSslSocket: cannot resolve CRYPTO_set_locking_callback
qt.network.ssl: QSslSocket: cannot resolve ERR_free_strings
qt.network.ssl: QSslSocket: cannot resolve EVP_CIPHER_CTX_cleanup
qt.network.ssl: QSslSocket: cannot resolve EVP_CIPHER_CTX_init
qt.network.ssl: QSslSocket: cannot resolve sk_new_null
qt.network.ssl: QSslSocket: cannot resolve sk_push
qt.network.ssl: QSslSocket: cannot resolve sk_free
qt.network.ssl: QSslSocket: cannot resolve sk_num
qt.network.ssl: QSslSocket: cannot resolve sk_pop_free
qt.network.ssl: QSslSocket: cannot resolve sk_value
qt.network.ssl: QSslSocket: cannot resolve SSL_library_init
qt.network.ssl: QSslSocket: cannot resolve SSL_load_error_strings
qt.network.ssl: QSslSocket: cannot resolve SSL_get_ex_new_index
qt.network.ssl: QSslSocket: cannot resolve SSLv2_client_method
qt.network.ssl: QSslSocket: cannot resolve SSLv3_client_method
qt.network.ssl: QSslSocket: cannot resolve SSLv23_client_method
qt.network.ssl: QSslSocket: cannot resolve SSLv2_server_method
qt.network.ssl: QSslSocket: cannot resolve SSLv3_server_method
qt.network.ssl: QSslSocket: cannot resolve SSLv23_server_method
qt.network.ssl: QSslSocket: cannot resolve X509_STORE_CTX_get_chain
qt.network.ssl: QSslSocket: cannot resolve OPENSSL_add_all_algorithms_noconf
qt.network.ssl: QSslSocket: cannot resolve OPENSSL_add_all_algorithms_conf
qt.network.ssl: QSslSocket: cannot resolve SSLeay
qt.network.ssl: QSslSocket: cannot resolve SSLeay_version
qt.network.ssl: QSslSocket: cannot call unresolved function CRYPTO_num_locks
qt.network.ssl: QSslSocket: cannot call unresolved function CRYPTO_set_id_callback
qt.network.ssl: QSslSocket: cannot call unresolved function CRYPTO_set_locking_callback
qt.network.ssl: QSslSocket: cannot call unresolved function SSL_library_init
qt.network.ssl: QSslSocket: cannot call unresolved function SSLv23_client_method
qt.network.ssl: QSslSocket: cannot call unresolved function sk_num
```

これはどうやら Unigine Superposition にくっついてくる QT のこのバージョンが Openssl-1.0 に対応してないから。LFS, BLFS はすでに 1.1 になっている。

なので、Openssl-1.0 のライブラリだけ ``$HOME/.local/share/Unigine_Superposition-1.0/bin/qt/lib`` に放り込んでやれば良い。幸い、1.0 のライブラリだけインストール済みだったので ``ln -sv /usr/lib/libssl.so.1.0.0 ./libssl.so`` で解決

<!-- vim: set tw=90 filetype=markdown : -->

