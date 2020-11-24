# kernel

```kernel
    Device Drivers --->
          Input device support --->
            <*>   Joystick interface
            <*>   Event interface
          HID support --->
            [*]   Battery level reporting for HID devices
            [*]   /dev/hidraw raw HID device support
            <*>   Generic HID driver
                  Special HID drivers --->
                    <*> Sony PS2/3/4 accessories
                    [*]   Sony PS2/3/4 accessories force feedback support
                USB HID support --->
                  <*> USB HID transport layer
      [*] LED Support --->
            <*>   LED Class Support
```

と Gentoo Wiki

# グループ

input に所属する必要がある

# SDL_GAMECONTROLLERCONFIG

```
export SDL_GAMECONTROLLERCONFIG="030000004c050000cc09000011810000,Sony Interactive Entertainment Wireless Controller,platform:Linux,x:b3,a:b0,b:b1,y:b2,back:b8,guide:b10,start:b9,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,dpup:h0.1,leftshoulder:b4,lefttrigger:a2,rightshoulder:b5,righttrigger:a5,leftstick:b11,rightstick:b12,leftx:a0,lefty:a1,rightx:a3,righty:a4,"
``` 

<!-- vim: set tw=90 filetype=markdown : -->

