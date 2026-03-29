# 普通の暗号化

```
> echo "hoge" | openssl enc -aes-256-cbc -a -salt -pbkdf2 -pass pass:hoge
U2FsdGVkX19LSWNP/jRniv2qRATxt1WBk4WDqK30Ljo=
```

``-aes-256-cbc -a -salt -pbkdf2`` まではお薦め定型文ということで。pass: は、その先がパスワ
ードだという宣言

ファイルを使うなら ``file:``、環境変数なら ``env:``

# 普通の複合化

```
> echo 'U2FsdGVkX19LSWNP/jRniv2qRATxt1WBk4WDqK30Ljo=' | openssl enc -aes-256-cbc -a -d
> -pbkdf2 -pass pass:hoge
hoge
```

# TPM2 を使う暗号化

まず TPM2 で秘密鍵と公開鍵を作成する。

```
> openssl genpkey -provider tpm2 -algorithm RSA -out tpm2-key.pem 
```

この .pem には公開鍵と、TPM2 の秘密鍵のアクセス用データとなっている。このデバイスでしか意
味を無さないので、pem は公開して OK

で、良く分かってないが、証明書を発行する。

```
> openssl req -provider tpm2 -provider default -x509 -new -inkey tpm2-key.pem -out \
 tpm2-cert.pem -subj "/CN=MySecrets/"
```

その証明書を使って、暗号化する。

```
> echo "export HOGE=hoge" | openssl cms -encrypt -recip tpm2-cert.pem \
-outform DER | base64 -w0 
MIIBsAYJKoZIhvcNAQcDoIIBoTCCAZ0CAQAxggFIMIIBRAIBADAsMBQxEjAQBgNVBAMMCU15U2VjcmV0cwIUKTecHDo2UgngRIOROHpcKf2pcrEwDQYJKoZIhvcNAQEBBQAEggEALr3VTybNx9MT/I7tcj4AC+Qt4FAiGAzOujwvahN+lx9/4QF/g9fTB7NEfDhyGOBvhNs82KNsZUqok0IVIRDjizQ07sO0Zu6rVMG+3os7bj51hdVS9lCexmm6QMno4L8NE7hoDO/R6mzOUG3pU3nxc7vBDUHbjZxEyi6owrMs2zwytMMKFX0Puk9Te5E5ue/DGr91kbI6uVCKm/IbeBGJzHJ6sU0sW5N2NF6A++T49kCRAvkeMpNSdrZQrnCD4MpHXDTXvLIGkYKJqO5/kchKcHBT7fMk6CiIJ/pN1c3VxBnLVzX+n2AImiRFr86vTcOJRiEhW4D9QZtXCMLYMs0n3TBMBgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBA5mG4drgRM2swh3Me9uLQWgCA/uOtdA0QzfUkWqU9+qgz203qZ2vJ98USEWl88EXneug==%                                                   
```

# TPM2 を使う復号化

```
echo \
"MIIBsAYJKoZIhvcNAQcDoIIBoTCCAZ0CAQAxggFIMIIBRAIBADAsMBQxEjAQBgNVBAMMCU15U2VjcmV0cwIUKTecHDo2UgngRIOROHpcKf2pcrEwDQYJKoZIhvcNAQEBBQAEggEALr3VTybNx9MT/I7tcj4AC+Qt4FAiGAzOujwvahN+lx9/4QF/g9fTB7NEfDhyGOBvhNs82KNsZUqok0IVIRDjizQ07sO0Zu6rVMG+3os7bj51hdVS9lCexmm6QMno4L8NE7hoDO/R6mzOUG3pU3nxc7vBDUHbjZxEyi6owrMs2zwytMMKFX0Puk9Te5E5ue/DGr91kbI6uVCKm/IbeBGJzHJ6sU0sW5N2NF6A++T49kCRAvkeMpNSdrZQrnCD4MpHXDTXvLIGkYKJqO5/kchKcHBT7fMk6CiIJ/pN1c3VxBnLVzX+n2AImiRFr86vTcOJRiEhW4D9QZtXCMLYMs0n3TBMBgkqhkiG9w0BBwEwHQYJYIZIAWUDBAEqBBA5mG4drgRM2swh3Me9uLQWgCA/uOtdA0QzfUkWqU9+qgz203qZ2vJ98USEWl88EXneug==%" |
base64 -d | \
openssl cms -decrypt -provider tpm2 -provider default -inkey ~/.ssl/tpm2-key.pem -recip \
 tpm2-cert.pem -inform DER                                                  
```

面倒くさいから ``systemd-creds`` でいいと思う。
