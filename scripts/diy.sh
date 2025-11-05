#!/usr/bin/env bash
set -euo pipefail
# diy.sh - customizations for onecloud-immortal build
# Adjust default LAN IP, disable DHCP, set kernel patch version, free space tricks.

# 1) Set default LAN IP and gateway in config_generate
if [ -f package/base-files/files/bin/config_generate ]; then
  sed -i 's/192.168.1.1/192.168.2.2/g' package/base-files/files/bin/config_generate || true
fi

# 2) Add uci defaults to set gateway and disable DHCP on LAN (will run on first boot)
mkdir -p files/etc/uci-defaults
cat > files/etc/uci-defaults/99-custom <<'EOF'
#!/bin/sh
uci set network.lan.gateway='192.168.2.1'
uci set dhcp.lan.ignore='1'
uci commit network
uci commit dhcp
EOF

# 3) Ensure root has empty password
mkdir -p package/base-files/files/etc
echo 'root::0:0:99999:7:::' > package/base-files/files/etc/shadow || true

# 4) Force kernel patch version if Makefiles allow
# Many targets read CONFIG_KERNEL_PATCHVER from .config; set in seed config instead.

# 5) Space-saving cleanups (remove common heavy packages from feeds if exist)
rm -rf feeds/packages/net/samba* || true
rm -rf feeds/packages/net/transmission* || true

# 6) Create resize-once script to expand overlay on first boot (try mmc/usb)
mkdir -p files/etc/init.d
cat > files/etc/init.d/resize_overlay <<'EOF'
#!/bin/sh /etc/rc.common
START=99
start() {
  logger -t resize_overlay "Attempting overlay resize..."
  # attempt ext4 resize on common partitions (device-specific)
  for dev in /dev/mmcblk0p2 /dev/sda2 /dev/nandb; do
    if [ -b "$dev" ]; then
      resize2fs "$dev" >/dev/null 2>&1 || true
    fi
  done
}
EOF
chmod +x files/etc/init.d/resize_overlay

# 7) Make scripts executable
find . -type f -name "*.sh" -exec chmod +x {} \; || true

echo "DIY changes applied."
