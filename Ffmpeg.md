# FFmpeg

OBS は音量の正規化ができない。
いくつか動画編集ツールも試してみたができない。
なので ffmpeg で行う。

https://trac.ffmpeg.org/wiki/AudioVolume

一番簡単なのは

```
ffmpeg -i input.wav -filter:a loudnorm output.wav
```

<!-- vim: set tw=90 filetype=markdown : -->
