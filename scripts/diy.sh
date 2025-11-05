#!/usr/bin/env bash
set -euo pipefail
KERNEL_V=${1:-6.6}
SRC_DIR="immortalwrt"
if [ ! -d "$SRC_DIR" ]; then
  echo "请在包含 immortalwrt 源的上级目录运行此脚本"
  exit 1
fi
cd "$SRC_DIR"

echo "应用自定义配置与补丁 — 内核: $KERNEL_V"

# 1) 复制 seed.config 到 .config（若存在）
if [ -f ../config/seed.config ]; then
  echo "复制 seed.config 到 .config"
  cp ../config/seed.config .config
else
  echo "未找到 config/seed.config —— 使用仓库默认配置"
fi

# 2) Make defconfig
make defconfig || true

# 3) 修改默认网络配置与关闭 DHCP（旁路由）
mkdir -p package/base-files/files/etc/config
cat > package/base-files/files/etc/config/network <<'EOF'
config interface 'loopback'
	option ifname 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config interface 'lan'
	option ifname 'eth0'
	option proto 'static'
	option ipaddr '192.168.2.2'
	option gateway '192.168.2.1'
	option netmask '255.255.255.0'
EOF

mkdir -p package/base-files/files/etc/init.d
cat > package/base-files/files/etc/init.d/zz-onecloud-dhcp-disable <<'EOF'
#!/bin/sh /etc/rc.common
START=95
start() {
    uci set dhcp.lan.ignore='1' || true
    uci commit dhcp || true
}
EOF
chmod +x package/base-files/files/etc/init.d/zz-onecloud-dhcp-disable

# 4) root 密码置空（警告：生产环境请谨慎）
mkdir -p package/base-files/files/etc
cat > package/base-files/files/etc/shadow <<'EOF'
root::0:0:99999:7:::
EOF

# 5) 内核版本标注
cat > files/KERNEL_VERSION <<EOF
$KERNEL_V
EOF

# 6) 尽量释放空间：清理临时文件，启用 ccache
rm -rf tmp/* || true
mkdir -p /tmp/ccache
export CCACHE_DIR=/tmp/ccache
export USE_CCACHE=1

# 7) 更新 feeds 并安装
./scripts/feeds update -a || true
./scripts/feeds install -a || true

cd - >/dev/null
echo "diy.sh 执行完成"
