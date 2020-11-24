# 起動できるかな

CONFIG_RELOCATABLE=n
動いた

CONFIG_NETFILTER_INGRESS=n iptables 動くかな
問題ないようだ

CONFIG_NF_CONNTRACK_PROCFS=n obso みたいだし消しても大丈夫？
問題ないようだ

CONFIG_MAC80211_LEDS=n, LED が見たことないし、あるかどうかも知らない
OK

CONFIG_ACPI_SPCR_TABLE=n, どうだろう、関係ないような。もしかして maple mini に関係ある？

  Enable support for Serial Port Console Redirection (SPCR) Table.  This table provides
  information about the configuration of the  earlycon console.

OK

<!-- vim: set tw=90 filetype=markdown fdm=marker cms=<!--\ %s\ -->: -->
