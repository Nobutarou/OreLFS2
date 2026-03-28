# ファン回転速度を制御

# カーネル

まず sysfs に pwm1 というのができてないとどうしようもない。kernel config で hwmon, i2c,
pwm あたりでモジュールにできそうなものを片っぱしから選択する。今の環境だと lsmod で

```
hwmon                  20480  4 k10temp,asus_wmi,amdgpu,fam15h_power
```

の 3 モジュールがヒットした。このうちファンの回転数を変えられるのは asus_wmi で、sysfs に

```
/sys/devices/platform/asus-nb-wmi/hwmon/hwmon2/{pwm1,pwm1_enable}
```

ができる。

# ファンの回転数を変える

上記の pwm1 が 0-255 まででファンの回転数を指定。指定すると pwm1_enable が自動的に 1 の
manual モードになる。pwm1_enable に 2 を入れると自動モードに戻る。このとき pwm1 に入れてあ
った数字は無視される。

今の環境だとなぜか大物ビルドしてるといつのまにか電源落ちていることがあったのだけど、どうも
2600-3000 rpm くらいでしか変動しないようだ。

# ファンの回転数を温度に応じて制御する

温度は k10temp が取ってくれている。

```
/sys/class/thermal/thermal_zone0/temp
```

を見れば分かる。
https://bitbucket.org/nobutarou_nosuke/simpleprograms/src/master/togglecpugoverner.c
を systemd のサービスにした。 /lib/systemd/system/toggle_cpu_gov_by_therm.service を

```
[Unit]
Description=Toggle CPU Governor by Temperature
[Service]
ExecStart=/usr/local/sbin/togglecpugoverner

[Install]
WantedBy=multi-user.target
```


