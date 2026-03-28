# Lxdm 

## .xsession を読みこませたい

現在、lightdm を途中で諦めたこともあり、

```zsh
 % cat /usr/share/xsessions/customxsession.desktop 
[Desktop Entry]
Type=Application
Name=Custom
Exec=/etc/lightdm/xsession
```
```zsh
 # cat /etc/lightdm/xsession 
source $HOME/.xsession
```
で .xsession は単に .xinitrc へのリンク

なのでおそらく、
```zsh
cat >  /usr/share/xsessions/customxsession.desktop  <<EOF
[Desktop Entry]
Type=Application
Name=Custom
Exec=/usr/local/bin/xsession
EOF

cat > /usr/local/bin/xsession <<EOF
source $HOME/.xsession
EOF
```

とでもすれば良いだろう。



<!-- vim: set tw=90 filetype=markdown : -->

