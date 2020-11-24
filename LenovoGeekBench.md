# kernel config
base: https://browser.geekbench.com/v5/cpu/4871850, single 899, multi 1607

CONFIG_PERF_EVENTS_INTEL_RAPL=m: Single 862, Multi 1656, adopt
CONFIG_RANDOMIZE_BASE=n: single 902, multi 1711, adopt
CONFIG_MICROCODE_OLD_INTERFACE=n: single 905, multi 1656, adopt for security
CONFIG_SCHED_MC=y: single 898, multi 1687, adopt (seems improved)
CONFIG_X86_AMD_FREQ_SENSITIVITY=m, single 902, multi 1693, adopt
<!-- vim: set tw=90 filetype=markdown : -->
