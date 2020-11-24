# AMDGPU

``CONFIG_DRM_AMD_DC_PRE_VEGA=no`` のとき kernel 起動オプションに ``amdgpu.dc=1`` だと起動
しない（まあ、そりゃそうなるな。なんで 4.13 まで動いてたんだか).  

``CONFIG_DRM_AMD_DC_PRE_VEGA=y`` なら ``amdgpu.dc=1`` で動く。AMD FreeSync と言うのが有効
になる模様。まあたぶん自分の A8-7410 ノートには関係ない。

<!-- vim: set tw=90 filetype=markdown fdm=marker cms=<!--\ %s\ -->: -->
