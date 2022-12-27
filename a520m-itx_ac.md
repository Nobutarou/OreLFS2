# LED controller がジョイスティックとして認識される。

/etc/udev/rules.d/51-asrock-led-joystick-fix.rules

```
SUBSYSTEM=="input", ATTRS{idVendor}=="26ce", ATTRS{idProduct}=="01a2", ENV{ID_INPUT_JOYSTICK}=="?*", ENV{ID_INPUT_JOYSTICK}=""
SUBSYSTEM=="input", ATTRS{idVendor}=="26ce", ATTRS{idProduct}=="01a2", KERNEL=="js[0-9]*", RUN+="/bin/rm %E{DEVNAME}", ENV{ID_INPUT_JOYSTICK}=""
SUBSYSTEM=="usb", ATTRS{idVendor}=="26ce", ATTRS{idProduct}=="01a2", ATTR{authorized}="0"
```

多分最後の行は不要

<!-- vim: set tw=90 filetype=markdown : -->

