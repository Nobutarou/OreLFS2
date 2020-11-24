# Gocryptfs を gccgo でビルドする

v1.7, v1.7.1 はビルドできない。

```
wget https://github.com/rfjakob/gocryptfs/releases/download/v1.6/gocryptfs_v1.6_src-deps.tar.gz 
```

して ~/go/src/github.com/rfjakob/gocryptfs に展開する。go が go ではなく gccgo であること
を確認して 

```
./build.bash
```

その build.bash には CFLAGS や LDFLAGS を -gccgoflags として通す

```
go build "-gccgoflags=-O1 -fprofile-generate=/sources/gcda/gocryptfs -fprofile-arcs -lgcov" "-ldflags=$LDFLAGS" "$@"
```



<!-- vim: set tw=90 filetype=markdown : -->
