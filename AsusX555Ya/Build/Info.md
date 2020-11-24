# /usr/share/info/dir の再構築

``zsh
cd /usr/share/info
rm dir
foreach f in * 
do
  install-info $f dir
done
``

とは言え、man しか使わないから、info は削除しちゃうのもあり。


<!-- vim: set tw=90 filetype=markdown : -->
