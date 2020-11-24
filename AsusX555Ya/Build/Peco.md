# gccgo で PGO する

```sh
export GOPATH=~/go 
cd $GOPATH/src/github.com/peco/
git clone git@github.com:peco/peco.git
glide install
go build   -compiler gccgo -gccgoflags "-O2 -fprofile-generate=$PWD" cmd/peco/peco.go
```

で peco が出きるので遊んだあとに

```sh
rm -v peco
go build   -compiler gccgo -gccgoflags "-O2 -fprofile-use=$PWD -march=native" cmd/peco/peco.go
```

``glide install`` でエラーが出たので ``rm -fr vendor ~/.glide glide.lock`` して解決


<!-- vim: set tw=90 filetype=markdown : -->
