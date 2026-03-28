# w3mhelp.cgi バグ

h 叩いてもヘルプが動かない。そこで
/usr/libexec/w3m/cgi-bin/w3mhelp.cgi を叩くと

```zsh
Can't use 'defined(%hash)' (Maybe you should just omit the defined()?) at /usr.....
```

なので、その指示に従い、defined() を削除するべし

<!-- vim: set tw=90 filetype=markdown : -->

