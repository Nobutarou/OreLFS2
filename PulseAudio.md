# I don't need to run pulseaudio in .xinitrc

pulseaudio can spawn when it is required. Check ~/.config/pulse/client.conf

```
 autospawn = yes
```

# Recommend to use pavucontrol

This is a gui front end. To build it, much more dependancies should be installed than
Pulsemixer. However, Pavucontrol shows much more infomations. For example, it shows a base
level of a microphone which Pulsemixer does not show. Obviously more useful.

# Check the hardware highest sampling rate and depth

For on-board,

```
grep rates /proc/asound/card0/codec\#0
grep bits /proc/asound/card0/codec\#0
```

For Sound Blaster Play 3

```
less /proc/asound/card2/stream0
```

# Check available resampling method

```
pulseaudio --dump-resample-methods
```

# how to use pactl

```
# set default output
# I can use tab completion in zsh.
pactl set-default-sink alsa_output.pci-0000_00_14.2.analog-stereo

# card profile
# On my laptop, the card has both input and output (duplex)
pactl set-card-profile alsa_card.pci-0000_00_14.2 output:analog-stereo+input:analog-stereo

# change volume
pactl set-sink-volume @DEFAULT_SINK@ -5%
pactl set-sink-volume @DEFAULT_SINK@ +5%

# toggle multe
pactl set-sink-mute @DEFAULT_SINK@ toggle

```

# front end
Pulsemixer is a good choice. The default setting uses spesial unicode chars and break the
view on some terminals. However, it can be configured. I can choose normal chars.

pamix is a better choice. However, it also uses special unicodes chars and break the view.
I can edit $src/include/pamix.hpp not to use special chars.
