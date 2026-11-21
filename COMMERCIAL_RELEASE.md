# RollKeep 仓库与发布维护说明

更新日期：2026-11-22

RollKeep 统一使用 [https://github.com/ZanwingMak/PhotoCleaner](https://github.com/ZanwingMak/PhotoCleaner) 维护，采用 GPL-3.0-only 开源。全部功能免费，不再区分商业仓和开源仓。

## 仓库与官网

- 唯一维护仓库：`ZanwingMak/PhotoCleaner`。
- 旧 `PhotoCleaner-OpenSource` 仓库停止维护，README 提供迁移入口，旧官网逐页跳转到新官网。
- 官网：https://zanwingmak.github.io/PhotoCleaner/
- 下载与版本：https://github.com/ZanwingMak/PhotoCleaner/releases
- 问题反馈：https://github.com/ZanwingMak/PhotoCleaner/issues
- GitHub Pages 使用 `main` 分支下的 `/docs` 发布。

## 应用配置

- 显示名：`RollKeep`；工程与 target 名称：`PhotoCleaner`。
- Bundle ID：`app.rollkeep.RollKeep`。
- 源码版本：`1.3.0`；构建号：`17`。这不代表该构建已上传到 App Store 或 TestFlight。
- 移除内购、订阅、付费墙和使用额度限制；整理统计、全部主题与完整时间线均可直接使用。
- 支持 iPhone 与 iPad，按当前窗口尺寸适配 Duo、横竖屏和分屏；不再设置 `UIRequiresFullScreen`。
- 工程采用自动签名，不固定开发者团队或分发描述文件；真机与商店发布由维护者自行选择签名资料。
- `scripts/build-ipa.sh` 输出未签名 IPA。

## 发布维护

源码、官网和 README 在同一仓库更新。发布前核对版本号、构建号、应用内网址和官网法律页面；不要把签名证书、描述文件或 API 私钥提交到仓库。

App Store 和 TestFlight 的发布操作独立完成。修改仓库或官网不会自动更新已经安装的客户端或商店中的二进制文件。
