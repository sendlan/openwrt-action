#!/bin/bash
# Copyright (c) 2022-2023 Curious <https://www.curious.host>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
# 
# https://github.com/Curious-r/OpenWrtBuildWorkflows
# Description: Automatically check OpenWrt source code update and build it. No additional keys are required.
#-------------------------------------------------------------------------------------------------------
#
#
# Patching is generally recommended.
# # Here's a template for patching:
#touch example.patch
#cat>example.patch<<EOF
#patch content
#EOF
#git apply example.patch
#修改immortalwrt.lan关联IP
sed -i 's/192.168.110.1/192.168.2.1/g' $(find feeds/luci/modules/luci-mod-system -type f -name "flash.js")
#修改默认IP地址.1/g' package/base-files/files/bin/config_generate
##-----------------Add OpenClash dev core------------------
curl -sL -m 30 --retry 2 https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz -o /tmp/clash.tar.gz
tar zxvf /tmp/clash.tar.gz -C /tmp >/dev/null 2>&1
chmod +x /tmp/clash >/dev/null 2>&1
mkdir -p feeds/luci/applications/luci-app-openclash/root/etc/openclash/core
mv /tmp/clash feeds/luci/applications/luci-app-openclash/root/etc/openclash/core/clash_meta >/dev/null 2>&1
rm -rf /tmp/clash.tar.gz >/dev/null 2>&1
##-----------------Fix Uboot-envtool-----------------
sed -i 's/_$(SUBTARGET)/_filogic/g' package/boot/uboot-envtools/Makefile

##-----------------Fix mtwifi-cfq 5g channel-----------------
sed -i 's/channel="36"/channel="auto"/g' package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

##-----------------Add passwall-----------------
mkdir -p package/atree
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git package/atree
git clone https://github.com/xiaorouji/openwrt-passwall2.git package/atree/openwrt-passwall2

