# Fan

Fan is not able to be controlled by Linux. The bios controlls. It seems that Performance
mode on BIOS is better than Intelligence mode.

# Battery conservation mode

```
echo 1 >/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
```

I am unsure whether it works. 

# GeekBench
base: https://browser.geekbench.com/v5/cpu/4871850, single 899, multi 1607

CONFIG_PERF_EVENTS_INTEL_RAPL=m: Single 862, Multi 1656, adopt
CONFIG_RANDOMIZE_BASE=n: single 902, multi 1711, adopt
CONFIG_MICROCODE_OLD_INTERFACE=n: single 905, multi 1656, adopt for security
CONFIG_SCHED_MC=y: single 898, multi 1687, adopt (seems improved)
CONFIG_X86_AMD_FREQ_SENSITIVITY=m, single 902, multi 1693, adopt

When CPU temp goes beyond 100 deg C, the bios drops down cpu freqs to 300MHz. It mainly
hurts the score.

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
