# FFmpeg

OBS は音量の正規化ができない。
いくつか動画編集ツールも試してみたができない。
なので ffmpeg で行う。

https://trac.ffmpeg.org/wiki/AudioVolume

一番簡単なのは、これだけど、なんだか音質が劣化する。

```
ffmpeg -i input.wav -filter:a loudnorm output.wav
```

ピークや RMS を調べて dB 上げる方法だと

```
ffmpeg -i input.wav -filter:a "volume=10dB" output.wav
```

<!-- vim: set tw=90 filetype=markdown : -->
