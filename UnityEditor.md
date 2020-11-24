# download

https://forum.unity.com/threads/unity-on-linux-release-notes-and-known-issues.350256/

の最後が最新。はじめてのとき、最初のを選んで全然ビルドできなかった。

Hollow Knight mods を Linux でビルドしたい一心で手をだしてみる。

# いくら待っても起動しない

Note: Hollow knight の mod ビルドするのに Unity3D 開発環境は必要ない

~/.config/unity3d/Editor.log に

```
CreateDirectory '/home/xxx/.local/share/unity3d/Unity' failed:
../../sandbox/linux/seccomp-bpf-helpers/sigsys_handlers.cc:**CRASHING**:seccomp-bpf failure in syscall 0281
[0502/154608:ERROR:sandbox_linux.cc(308)] InitializeSandbox() called with multiple threads in process gpu-process
[0502/154608:ERROR:gpu_process_transport_factory.cc(402)] Failed to establish GPU channel.
```

Create Direcotry の failed は謎. install -dv でもしておけば消える。mkdir でも使ってんのかな。

だけど seccomp-bpf か。kernel config になにかあった気がする。どうかな。 --> 同じエラーが出た。

```
CONFIG_BPF_SYSCALL = y

# こっちは y にしてあったけど、一応記述
CONFIG_SECCOMP = y
```


<!-- vim: set tw=90 filetype=markdown : -->
