# after upgrading kernel, it stopped working. 2021.09.08

I don't know when. I check kernel config and find that I need,

```
CONFIG_I2C_HID_ACPI=m
CONFIG_I2C_HID_OF=m
CONFIG_I2C_HID_OF_GOODIX=m
```

I might not need those modules. However, they are the trigger to build i2c_hid module. And
it seems that the Lenovo touchpad need the module.

# Lenovo S340 Touchpad is not recognized

The host, Ubuntu can recognize, but my LFS cannot.

All of CONFIG_INPUT_MOUSE to <m> or <y>.
All of CONFIG_INPUT_MOUSE to <m> or <y>.]

According to Archwiki, https://wiki.archlinux.org/index.php/Laptop#Touchpad, I might need
some combination of 

```
i8042.noloop i8042.nomux i8042.nopnp i8042.reset
```

Without any kernal options, not recognized. 
With i8042.noloop, no.
With i8042.nomux, no
With i8042.nopnp, no.
WIth i8042.reset, no.

With i8042.noloop and 8042.nomux, no.
With i8042.noloop and 8042.nopnp, no.
With i8042.noloop and 8042.reset, no.

With i8042.nomux and 8042.nopnp, no.
With i8042.nomux and 8042.reset, no.

With i8042.nopnp i8042.reset, no

With i8042.noloop i8042.nomux i8042.nopnp, no.
With i8042.noloop i8042.nomux i8042.reset, no.
With i8042.noloop i8042.nopnp i8042.reset, no.
With i8042.nomux 8042.nopnp i8042.reset, no.

with i8042.noloop i8042.nomux i8042.nopnp i8042.reset, no.

All of Multifunction device drivers to <m>, no

According to https://forums.gentoo.org/viewtopic-t-1086512-start-0.html, I set <M> for all
under device -> pincontrollers,

Wow, finally work. The functionkey, fn+F6 also works without any binding.

<!-- vim: set tw=90 filetype=markdown : -->

