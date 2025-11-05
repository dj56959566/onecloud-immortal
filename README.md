onecloud-immortal/

├── .github/

│       └── workflows/

│          └── build.yml  # GitHub Actions 自动编译脚本（完整稳定版）

├── feeds.conf.default         # 修复后的 feed 列表（含 Nikki / OpenClash）

├── config_fragments/

│       └── onecloud_defconfig     # OneCloud 默认编译配置

└── files/                     # 可放系统默认文件（如 /etc/config/network 等）



# OneCloud ImmortalWrt 

自动构建基于 **ImmortalWrt (ARMv7)** 的 OneCloud 固件。

### ✨ 特点
- 适配 OneCloud ARMv7
- 插件：Docker、Netdata、文件传输、网页终端、定时任务
- 固定 IP：`192.168.2.2` / 网关：`192.168.2.1`
- 关闭 DHCP
- 内核在线升级支持（系统 → 软件包 / 系统升级）
- 每天自动同步官方更新并编译
- 输出：U 盘启动版 + 线刷版（sysupgrade）

### 🧰 使用方式
1. Fork 本仓库到你的 GitHub
2. 进入 **Actions** 页面 → 运行 “Build ImmortalWrt OneCloud”
3. 编译完成后在 Artifacts 下载镜像：
   - `*sdcard.img.gz` → U 盘启动版  
   - `*sysupgrade.bin` → 线刷升级版

================================================================================

玩客云u-boot https://github.com/hzyitc/u-boot-onecloud

线刷包打包工具 https://github.com/hzyitc/AmlImg

此人作品也不错 https://github.com/shiyu1314/openwrt-onecloud

所有为openwrt做出贡献的人
