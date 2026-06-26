# RollKeep 商业发行改造说明

更新日期：2026-06-26

本文记录 PhotoCleaner 改造为 RollKeep 商业发行形态时的仓库、签名、命名和 TestFlight 发布配置。该文档面向项目维护，不作为对外介绍页面。

## 改造目标

- 保留原有照片整理与清理能力，面向 App Store/TestFlight 以 RollKeep 名称发布。
- 参考 SynoMusic 的方式拆分为两个仓库：商业私密代码库与公开开源代码库。
- 商业发行使用独立 Bundle ID，不继续使用个人姓名相关标识。
- 先通过 TestFlight 完成内部/外部测试，再进入正式上架流程。

## 仓库边界

### 商业私密仓

- 本地路径：`/Users/maizhenying/Code/my_project/PhotoCleaner`
- 远程仓库：`ZanwingMak/PhotoCleaner`
- 仓库可见性：Private
- 用途：商业发行、App Store/TestFlight 上传、私密配置与后续商业化迭代。

### 公开开源仓

- 本地路径：`/Users/maizhenying/Code/my_project/PhotoCleaner-OpenSource`
- 远程仓库：`ZanwingMak/PhotoCleaner-OpenSource`
- 仓库可见性：Public
- 用途：公开源码、开源协作、公开 Issue/Release/README。

商业私密仓可以向开源仓同步适合公开的通用代码，但不要把签名资料、证书、私密配置、未公开商业计划或 App Store Connect 相关敏感信息同步到开源仓。

## 当前应用身份

- App Store Connect App 名称：`RollKeep`
- 用户可见 App 显示名：`RollKeep`
- Bundle ID：`app.rollkeep.RollKeep`
- 当前 TestFlight 构建：`1.1.9 (10)`
- 内部 target / executable 名称：仍保留 `PhotoCleaner`

内部工程名保留 `PhotoCleaner` 是为了降低大范围重命名带来的风险；它不影响 App Store 名称、桌面显示名或 Bundle ID。

## 命名与文案调整

已将用户可见层面的品牌名从 `PhotoCleaner` / `Photo Cleaner` 调整为 `RollKeep`，覆盖范围包括：

- `Info.plist` 中的 `CFBundleDisplayName`
- 相册权限弹窗文案
- App 内标题、设置页、空状态等可见文本
- 多语言 `InfoPlist.strings`
- 构建脚本中的 App 显示名与导出 IPA 文件名

开源仓中 GitHub 链接、Issue 链接、更新检查仓库已指向 `PhotoCleaner-OpenSource`。

## 签名与发布配置

商业私密仓使用 Apple Developer Team：

- Team ID：`2Q2LMV7BR6`
- Debug：Automatic Signing
- Release：Manual Signing
- Release Certificate：`Apple Distribution`
- Provisioning Profile：`RollKeep App Store`

关键配置：

- `PRODUCT_BUNDLE_IDENTIFIER = app.rollkeep.RollKeep`
- `CODE_SIGN_STYLE = Manual` 仅用于 Release
- `PROVISIONING_PROFILE_SPECIFIER = RollKeep App Store`
- `UIRequiresFullScreen = true`
- `ITSAppUsesNonExemptEncryption = false`

`UIRequiresFullScreen` 用于满足当前 iPhone-only 竖屏应用的上传要求。`ITSAppUsesNonExemptEncryption=false` 表示当前应用未使用需要额外出口合规文稿的加密能力，后续新构建可减少 App Store Connect 重复询问。

## TestFlight 状态

已完成：

- 创建 App Store Connect App：`RollKeep`
- 创建并关联 Bundle ID：`app.rollkeep.RollKeep`
- 使用 App Store 分发证书与 profile 完成 archive
- 上传构建 `1.1.9 (10)` 到 App Store Connect
- 构建在 TestFlight 页面显示为“准备提交”
- App 加密文稿选择“不属于上述的任意一种算法”

下一步：

- 内部测试：在 TestFlight 的内部测试群组中添加构建 `1.1.9 (10)` 并邀请测试员。
- 外部测试：创建或进入外部测试群组，选择构建并提交 Beta 审核。

## 后续维护规则

- 商业私密仓是 App Store/TestFlight 的发布源。
- 开源仓只保留适合公开的源码与公开项目信息。
- 修改品牌、Bundle ID、签名、发布脚本时，先确认商业私密仓；确实适合公开的部分再同步到开源仓。
- 发布前检查 `Info.plist`、`project.pbxproj`、`scripts/build-ipa.sh` 是否仍保持 RollKeep / `app.rollkeep.RollKeep` 配置。
- 不要提交 `.mobileprovision`、`.p12`、私钥、App Store Connect API Key 或其它账户凭据。
- 如果未来引入自定义加密、登录、支付、云同步、订阅或分析能力，需要重新评估隐私政策、加密合规、数据收集声明和 App Store 审核信息。

## 发布前检查清单

- Bundle ID 为 `app.rollkeep.RollKeep`
- App 显示名为 `RollKeep`
- Release 使用 `Apple Distribution` 与 `RollKeep App Store`
- `UIRequiresFullScreen` 为 `true`
- `ITSAppUsesNonExemptEncryption` 为 `false`
- 版本号与构建号已递增
- Debug 模拟器构建通过
- Release archive 成功
- TestFlight 上传成功
- App Store Connect 中测试信息、截图、隐私信息、加密文稿状态填写完整
