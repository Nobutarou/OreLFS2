# いくら待っても起動しない

```
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
```

あたりがカーネルに必要。エラー出してくれたらわかるんだけど。

# DS4 反応が以上にわるい

SDL_GAMECONTROLLERCONFIG つけないとコントローラがあることすら認識しない。ds4drv で xpad
偽装しても認識しない。

Arch wiki と Gentoo wiki にモーションセンサーが悪さをしている説が書かれていた. udev rule として

```
SUBSYSTEM=="input", ATTRS{name}=="*Controller Motion Sensors", RUN+="/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
#SUBSYSTEM=="input", ATTRS{name}=="*Controller Touchpad", RUN+="/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
```

としたら解決。Arch, Gentoo みたいに Touchpad まで無効にする必要はなかった

# mod を使う。

## Assembly-CSharp.dll

```
git clone https://github.com/seanpr96/HollowKnight.Modding.git 
cd HollowKnight.Modding
mkdir -v Vanilla
cp -v ~/GOG\ Games/Hollow\ Knight/game/hollow_knight_Data/Managed/* Vanilla
xbuild
```

してもいろいろ error が出た。まず .net 4.7.2 じゃないとビルドできないみたい。そして
mono-5.20.1.27 が 4.7.2 対応なので、mono をアップデート

それから Prepatcher/Prepatcher.csproj の最後で obj/Debug/Prepatcher.exe を ./
にコピーしてると思うんだけど、move を mv
に置きかえたりなんなしてもエラーなので（パスの基準が私がわかってない）、エラーの後でも
Prepathcer.exe は出きているので自分でコピーすることにして、コメントアウト。

```
  <PropertyGroup>
    <!-- <PostBuildEvent>mv obj/Debug/Prepatcher.exe ./</PostBuildEvent> -->
  </PropertyGroup>
```

次は Assembly-CSharp で move だの copy だのが無いという。なぜか
Assembly-CSharp/Assembly-CSharp.csproj には <PostBuildEvent>
が二つある。どうにも同じことをしているようだが、最初のは Unix 系 OS 向けに mv とか cp
で書かれてちゃんと動くようなので二つ目をコメントアウトした. 二つ目は最後の方にある。

## Bonfire

```
git clone https://github.com/Ayugradow/BonfireMod
```

Properties/AssemblyInfo.cs がないと文句を言われるので、touch する。

次々に namespace が無いと言われるので BonfireMod.csproj はこうなった.
よく仕組みを知らないんだけど HintPath を一度書いておくとそこのディレクトリの dll を
bin/debug にコピーしてくるみたい。逆に言うと bin/debug に置いておけば HintPath
不要みたい。ということで後半は Hollow Knight バンドルdll を bin/debug にコピーした.

```
    <Reference Include="Assembly-CSharp, Version=0.0.0.0, Culture=neutral, processorArchitecture=MSIL"
>
      <SpecificVersion>False</SpecificVersion>
      <HintPath>/home/snob/GOG Games/Hollow Knight/game/hollow_knight_Data/Managed/Assembly-CSharp.dll
</HintPath>
    </Reference>
    <Reference Include="ModCommon">
      <HintPath>/home/snob/GOG Games/Hollow Knight/game/hollow_knight_Data/Managed/Mods/ModCommon.dll</HintPath>
    </Reference>
    <Reference Include="PlayMaker">
      <HintPath>/home/snob/GOG Games/Hollow Knight/game/hollow_knight_Data/Managed/PlayMaker.dll</HintPath>
    </Reference>
    <Reference Include="System" >
    </Reference>
    <Reference Include="mscorlib.dll" />
    <Reference Include="System.Core" />
    <Reference Include="System.Xml.Linq" />
    <Reference Include="System.Data.DataSetExtensions" />
    <Reference Include="System.Data" />
    <Reference Include="System.Xml" />
    <Reference Include="UnityEngine">
      <HintPath>/home/snob/GOG\ Games/Hollow\ Knight/game/hollow_knight_Data/Managed/UnityEngine.dll</HintPath>
    </Reference>
    <Reference Include="UnityEngine.UI">
      <HintPath>/home/snob/GOG Games/Hollow Knight/game/hollow_knight_Data/Managed/UnityEngine.UI.dll</HintPath>
    </Reference>
    <Reference Include="UnityEngine.CoreModule">
      <HintPath>/home/snob/GOG Games/Hollow Knight/game/hollow_knight_Data/Managed/UnityEngine.CoreModule.dll</HintPath>
    </Reference>
    <Reference Include="UnityEngine.Physics2DModule.dll" >
    </Reference>
    <Reference Include="UnityEngine.IMGUIModule" />
```

dll の見付け方だけど例えば Collider2D が見つからないと言われたとき using =
UnityEngine.Collider2D とかって cs に書いてやると, その namespace は別の dll
にフォワードされてるとか言われるので、それを Reference で追加した。

BonfireMod.cs は自分が強くなると相手の HP も増えるので、それを変えたければこの式を変える。

```
 hm.hp *= (int)((1.25 + (double)Dreamers / 3) * (2.5 / (1.0 + Math.Exp(-0.05 * Settings.CurrentLv))));
``` 

釘の強化は本来は 4 ずつだけど、この mod では 2 ずつにしてる。戻したければ、LevellingSystem.cs の 

```
        public int NailDamage(int totalStr) => (int)Math.Round((double)(5 + 2 * PlayerData.instance.nailSmithUpgrades) * Math.Pow(1.25, Math.Log((double)totalStr, 2.0)));
```

## modcommon

```
git clone git@github.com:Kerr1291/ModCommon.git
```

<hintpath> の基準が分からないのでフルパスで書く。面倒なので、そこに全部の dll を置いてみる
と動いた。


<!-- vim: set tw=90 filetype=markdown : -->
