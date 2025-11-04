# OneCloud ImmortalWrt Auto Builder

自动构建基于 **ImmortalWrt (ARMv7)** 的 OneCloud 固件。

### ✨ 特点
- 适配 OneCloud ARMv7
- 插件：OpenClash、Nikki、Docker、Netdata、文件传输、网页终端、定时任务
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
