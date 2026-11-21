import StoreKit
import SwiftUI

/// 自愿赞助页：所有功能始终免费，赞助不附带权益或自动续费。
struct SponsorshipView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: SponsorshipStore
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var lm: LanguageManager
    @State private var showThanks = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(AppPalette.brand)
                    Text(lm.t("感谢赞助开发"))
                        .font(.largeTitle.bold())
                    Text(lm.t("如果 RollKeep 帮你整理了照片，欢迎支持它继续成长。"))
                        .foregroundStyle(.secondary)
                    Text(lm.t("所有功能免费开放。赞助完全自愿，不解锁额外功能，也不会自动续费。"))
                        .font(.callout)

                    if store.isLoading {
                        ProgressView(lm.t("正在加载赞助项目"))
                            .frame(maxWidth: .infinity, minHeight: 100)
                    } else {
                        ForEach(store.products, id: \.id) { product in
                            sponsorshipButton(product)
                        }
                        if store.products.isEmpty {
                            Button(lm.t("重新加载")) {
                                Task { await store.loadProducts() }
                            }
                            .buttonStyle(.bordered)
                        }
                    }

                    if let message = store.message {
                        Text(lm.t(message))
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .accessibilityAddTraits(.updatesFrequently)
                    }
                    Text(lm.t("每次赞助均为一次性消耗型购买，可以重复支持；不包含需要恢复的功能权益。"))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Link(lm.t("管理历史订阅"), destination: URL(string: "https://apps.apple.com/account/subscriptions")!)
                    HStack(spacing: 20) {
                        Link(lm.t("使用条款 (EULA)"), destination: URL(string: "https://zanwingmak.github.io/PhotoCleaner/terms.html")!)
                        Link(lm.t("隐私政策"), destination: URL(string: "https://zanwingmak.github.io/PhotoCleaner/privacy.html")!)
                    }
                    .font(.footnote)
                }
                .padding(24)
                .frame(maxWidth: 680)
                .frame(maxWidth: .infinity)
            }
            .background(AppPalette.bgPrimary(for: themeManager.current))
            .navigationTitle(lm.t("赞助支持"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(lm.t("关闭")) { dismiss() }
                        .disabled(store.isPurchasing)
                }
            }
            .task { await store.loadProducts() }
            .interactiveDismissDisabled(store.isPurchasing)
            .alert(lm.t("感谢你的赞助与支持！"), isPresented: $showThanks) {
                Button(lm.t("确认"), role: .cancel) { }
            }
        }
        .preferredColorScheme(themeManager.current.colorScheme)
    }

    /// 使用苹果返回的本地化名称和地区价格，防止连续触发购买。
    private func sponsorshipButton(_ product: Product) -> some View {
        Button {
            Task {
                if await store.purchase(product) {
                    AppHaptics.impact(.soft)
                    showThanks = true
                }
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "heart")
                    .foregroundStyle(AppPalette.brand)
                Text(product.displayName)
                Spacer()
                if store.isPurchasing { ProgressView() }
                Text(product.displayPrice)
                    .fontWeight(.semibold)
            }
            .padding(18)
            .frame(minHeight: 56)
            .background(AppPalette.bgCard(for: themeManager.current), in: RoundedRectangle(cornerRadius: 16))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(store.isPurchasing)
        .accessibilityLabel("\(product.displayName), \(product.displayPrice)")
    }
}
