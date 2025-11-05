#!/bin/bash
# === OneCloud ImmortalWrt 自定义构建脚本 ===
set -e
echo "[DIY] 开始自定义系统配置..."

# 保守处理：仅在正确路径下修改文件
if [ -d "package/base-files/files" ]; then
  # 修改默认 IP
  sed -i 's/192.168.1.1/192.168.2.2/g' package/base-files/files/bin/config_generate || true

  # 关闭 DHCP（旁路由模式）
  if [ -f package/base-files/files/etc/config/dhcp ]; then
    sed -i '/dhcp.lan/,+5d' package/base-files/files/etc/config/dhcp || true
  fi

  # 清空 root 密码（生成时为空密码）
  if [ -f package/base-files/files/etc/shadow ]; then
    sed -i 's/root:::0:99999:7:::/root::0:0:99999:7:::/g' package/base-files/files/etc/shadow || true
  fi

  # 替换 feeds.conf 或 feeds.conf.default 中的下载源镜像（若存在）
  if [ -f feeds.conf.default ]; then
    sed -i 's#downloads.openwrt.org#mirrors.tuna.tsinghua.edu.cn/openwrt#g' feeds.conf.default || true
  fi

  # 添加一个标记说明默认使用 6.6 LTS 内核，可在 workflow_dispatch 时覆盖
  echo "# Default kernel: 6.6 LTS. Can override via workflow input 'kernel_version'." > files/etc/banner || true

  # 将 overlay 检查脚本写入 rc.local，设备启动时会显示 overlay 信息
  mkdir -p package/base-files/files/etc
  cat >> package/base-files/files/etc/rc.local <<'EOF'
# OneCloud overlay check
echo "[Overlay] Available space:"
df -h /overlay || true
EOF

else
  echo "[DIY] Warning: expected openwrt tree not found; skipping file edits."
fi

echo "[DIY] 自定义配置完成。"
