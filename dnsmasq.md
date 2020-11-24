# systemd script

/usr/lib/systemd/system/dnsmasq.service
``
[Unit]
Description=A lightweight DHCP and caching DNS server
After=network.target
Documentation=man:dnsmasq(8)

[Service]
Type=dbus
BusName=uk.org.thekelleys.dnsmasq
ExecStartPre=/usr/bin/dnsmasq --test
ExecStart=/usr/bin/dnsmasq   --pid-file
ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
``

Arch を見ると --enable-dbus と -k が付くのだけど、うまくいかないからあきらめ

# config

dns 使いたいときは server=行が必要なみたいだ. resolv-file= 行では無いようだ。よくわからん

# networkmanager

を使うと /etc/dnsmasq.conf を無視するようである
<!-- vim: set tw=90 filetype=markdown : -->

