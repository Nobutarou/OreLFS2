# asound.conf  

ちょっと前まで /etc/asound.conf は

```
pcm.!default {
	type hw
	card 1
}

ctl.!default {
	type hw           
	card 1
}
```

で、これだと firefox で音が出ないので、

```
defaults.ctl.card 1;
defaults.pcm.card 1;
```

にしたら音が出た。https://is.gd/FhcLY5 に違いが書いてあるけど理解できない。

# Pulseaudio

テラリアで Pulseaudio を入れるとフリーズしなくなるという情報を得て入れると、勝手にミュート
してしまうという事態が発生。alsamixer の右の方に auto mute と言う項目があるので、disabled
にすると大丈夫かな。



<!-- vim: set tw=90 filetype=markdown : -->

