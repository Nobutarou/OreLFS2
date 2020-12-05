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

<!-- vim: set tw=90 filetype=markdown : -->

