# 16 系

ビルドできなくてあきらめた。

# 15 系

mono のバージョンとか関係してんのかと思って下げてみた。 /etc/os-release がいつのまにか空に
なっているのが原因でビルドスクリプトが落ちていた。もしかして 16 も通るのかも

結局最後は

```
/home/snob/.nuget/packages/roslyntools.repotoolset/1.0.0-beta2-62901-01/tools/RepositoryInfo.targets(13,5):
error : GitHeadSha has invalid value: ''
[/sources/msbuild-15.8.169.51996/src/Framework/Microsoft.Build.Framework.csproj]
/home/snob/.nuget/packages/roslyntools.repotoolset/1.0.0-beta2-62901-01/tools/RepositoryInfo.targets(13,5):
error : GitHeadSha has invalid value: ''
[/sources/msbuild-15.8.169.51996/src/Framework/Microsoft.Build.Framework.csproj]
/
```

みたいなの乱発で error

<!-- vim: set tw=90 filetype=markdown : -->
