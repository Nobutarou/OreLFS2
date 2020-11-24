# デフォルトデバイスの選択を modprobe.d で行う方法は危険

/etc/asound.conf で入れかえる方法は Archwiki の方法では Firefox 等で音が出なかったり
(Pulseaudio 付きでビルドしなおせば良いのだろうけど）、いろいろな設定を試してもうまく働かな
いから、modprobe の方法で入れかえる。

自分のは hdmi も普通の方も snd_hda_intel を使うので、ちょっと工夫が必要だった

```
% lspci -nn | grep -i audio 
00:01.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Kabini HDMI/DP Audio [1002:9840]
00:14.2 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] FCH Azalia Controller [1022:780d] (rev 02)
```

の 後ろの [] の数字を使って /etc/modprobe.d/alsa.conf

```
options snd_hda_intel index=0 model=auto vid=1002 pid=780d
options snd_hda_intel index=1 model=auto vid=1002 pid=9840
```

これで aplay -l すると

```
**** ハードウェアデバイス PLAYBACK のリスト ****
カード 0: Generic [HD-Audio Generic], デバイス 0: CX20751/2 Analog [CX20751/2 Analog]
  サブデバイス: 1/1
  サブデバイス #0: subdevice #0
カード 1: HDMI [HDA ATI HDMI], デバイス 3: HDMI 0 [HDMI 0]
  サブデバイス: 1/1
  サブデバイス #0: subdevice #0
```

ところが 

```zsh
pacmd list sinks
```

すると HDMI しか出てこないという罠。

# デフォルトデバイスは .asoundrc でやるほうが無難

```
defaults.ctl.card 1;
defaults.pcm.card 1;
```

Arch の pcm.!default {} のやつは firefox で音が出ない。やはり firefox も pulse 付きでビル
ドすべきだろう

<!-- vim: set tw=90 filetype=markdown : -->
