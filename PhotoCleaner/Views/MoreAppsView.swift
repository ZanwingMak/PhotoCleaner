import SwiftUI

/// 开发者的其他已上架应用；仅在用户主动点击时打开官方商店。
struct MoreAppsView: View {
    @EnvironmentObject private var lm: LanguageManager
    @EnvironmentObject private var themeManager: ThemeManager

    private let apps: [(id: String, name: String, summary: String, platform: String)] = [
        ("6784094020", "SynoMusic", "连接自己的音乐库，随时聆听。", "iPhone · iPad · Mac"),
        ("6792962753", "MeloGo", "本地优先的音乐播放器。", "iPhone · iPad"),
        ("6806893112", "Kanata", "连接自己的媒体库，继续观看。", "iPhone · iPad · Apple TV"),
        ("6821692076", "Nightfall", "在大屏幕上享受自然声音与画面。", "Apple TV")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(lm.t("更多独立开发的应用，欢迎看看。"))
                    .foregroundStyle(.secondary)
                ForEach(apps, id: \.id) { app in
                    appLink(app)
                }
                Link(lm.t("查看开发者的所有 App"),
                     destination: URL(string: "https://apps.apple.com/developer/id6784051703")!)
                    .padding(.vertical, 12)
            }
            .padding(20)
            .frame(maxWidth: 680)
            .frame(maxWidth: .infinity)
        }
        .background(AppPalette.bgPrimary(for: themeManager.current))
        .navigationTitle(lm.t("开发者的其他 App"))
        .navigationBarTitleDisplayMode(.inline)
    }

    /// 展示随应用打包的官方图标和平台说明，不执行广告或点击追踪。
    private func appLink(_ app: (id: String, name: String, summary: String, platform: String)) -> some View {
        Link(destination: URL(string: "https://apps.apple.com/app/id\(app.id)")!) {
            HStack(alignment: .top, spacing: 14) {
                Image("DeveloperApp\(app.id)")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 6) {
                    Text(app.name).font(.headline)
                    Text(lm.t(app.summary)).font(.subheadline)
                    Text(app.platform).font(.caption).foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "arrow.up.right").foregroundStyle(AppPalette.brand)
            }
            .foregroundStyle(.primary)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppPalette.bgCard(for: themeManager.current), in: RoundedRectangle(cornerRadius: 18))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(lm.t("在 App Store 中查看"))
    }
}
