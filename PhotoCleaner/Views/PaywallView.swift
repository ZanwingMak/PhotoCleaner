//
//  PaywallView.swift
//  订阅与买断付费墙：可信三档商品 + 免费试用 + 恢复购买 + App 兑换码
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    /// 触发付费墙的原因（用于顶部副标提示，可选）
    var reason: PaywallReason = .upgrade

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: StoreService
    @EnvironmentObject private var lm: LanguageManager
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var selectedID: String?
    @State private var showRedeemSheet = false
    @State private var toast: ToastInfo?
    @State private var eligibleTrialProductIDs = Set<String>()

    var body: some View {
        NavigationStack {
            ZStack {
                AppPalette.bgPrimary(for: themeManager.current).ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        hero
                        featureList
                        plansList
                        ctaSection
                        legalAndRestore
                        Color.clear.frame(height: 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                }
            }
            .toast($toast)
            .preferredColorScheme(themeManager.current.colorScheme)
            .navigationTitle(lm.t("升级会员"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(lm.t("关闭")) { dismiss() }
                        .tint(AppPalette.brand)
                }
            }
            .task {
                if store.products.isEmpty {
                    await store.loadProducts()
                }
                await refreshTrialEligibility()
                // 默认选中年订阅
                if selectedID == nil {
                    selectedID = sortedProducts.first(where: { $0.id == StoreProductID.yearly.rawValue })?.id
                        ?? sortedProducts.first?.id
                }
            }
            // iOS 16+ App Store 兑换码内置 sheet
            .offerCodeRedemption(isPresented: $showRedeemSheet) { _ in }
            .onChange(of: store.isPro) { _, newValue in
                if newValue { dismissWithSuccess() }
            }
        }
    }

    // MARK: - 顶部 Hero

    private var hero: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(AppPalette.brandGradient)
                    .frame(width: 88, height: 88)
                Image(systemName: "crown.fill")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(.white)
            }
            .shadow(color: AppPalette.brand.opacity(0.5), radius: 18, x: 0, y: 10)

            Text(lm.t("解锁完整体验"))
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(AppPalette.textPrimary(for: themeManager.current))

            Text(lm.t(reason.subtitleKey))
                .font(.system(size: 13))
                .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .padding(.top, 6)
    }

    // MARK: - 特性列表

    private var featureList: some View {
        VStack(spacing: 12) {
            featureRow(symbol: "infinity",
                       title: lm.t("无限审核"),
                       desc: lm.t("每天可整理的张数不再受限"))
            featureRow(symbol: "externaldrive.fill.badge.plus",
                       title: lm.t("空间优先整理"),
                       desc: lm.t("优先查看最占空间的照片和视频"))
            featureRow(symbol: "calendar.badge.clock",
                       title: lm.t("完整时间线"),
                       desc: lm.t("回顾全部月份，不限最近半年"))
            featureRow(symbol: "chart.bar.fill",
                       title: lm.t("整理洞察"),
                       desc: lm.t("查看释放空间、连续天数和趋势"))
            featureRow(symbol: "paintbrush.fill",
                       title: lm.t("解锁全部主题"),
                       desc: lm.t("解锁焦糖暖与冷色主题"))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppPalette.bgCard(for: themeManager.current))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(.primary.opacity(0.05), lineWidth: 1)
                )
        )
    }

    private func featureRow(symbol: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle().fill(AppPalette.brand.opacity(0.18))
                    .frame(width: 30, height: 30)
                Image(systemName: symbol)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(AppPalette.brand)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppPalette.textPrimary(for: themeManager.current))
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
            }
            Spacer()
        }
    }

    // MARK: - 商品列表

    /// 按枚举顺序权重排序的商品
    private var sortedProducts: [Product] {
        store.products.sorted {
            let l = StoreProductID(rawValue: $0.id)?.sortOrder ?? 99
            let r = StoreProductID(rawValue: $1.id)?.sortOrder ?? 99
            return l < r
        }
    }

    private var plansList: some View {
        VStack(spacing: 10) {
            if sortedProducts.isEmpty {
                if store.isLoading {
                    ProgressView()
                        .tint(AppPalette.brand)
                        .padding(.vertical, 30)
                } else {
                    VStack(spacing: 10) {
                        Text(lm.t("暂时无法加载商品"))
                            .font(.subheadline)
                            .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
                        Button(lm.t("重新加载")) {
                            Task { await store.loadProducts() }
                        }
                        .buttonStyle(.bordered)
                        .tint(AppPalette.brand)
                    }
                    .padding(.vertical, 22)
                }
            } else {
                ForEach(sortedProducts, id: \.id) { product in
                    planRow(product)
                }
            }
        }
    }

    private func planRow(_ product: Product) -> some View {
        let pid = StoreProductID(rawValue: product.id)
        let isSelected = selectedID == product.id
        let isYearly = pid == .yearly
        return Button {
            AppHaptics.impact(.soft)
            selectedID = product.id
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? AppPalette.brand : .primary.opacity(0.18), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle().fill(AppPalette.brand).frame(width: 12, height: 12)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 8) {
                        Text(lm.t(pid?.titleKey ?? product.displayName))
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(AppPalette.textPrimary(for: themeManager.current))
                        if isYearly {
                            Text(lm.t("最受欢迎"))
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Capsule().fill(AppPalette.brand.opacity(0.18)))
                                .foregroundStyle(AppPalette.brand)
                        }
                    }
                    Text(lm.t(pid?.periodKey ?? ""))
                        .font(.system(size: 11))
                        .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
                    if eligibleTrialProductIDs.contains(product.id),
                       let days = product.freeTrialDays {
                        Text(String(format: lm.t("含 %d 天免费试用"), days))
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(AppPalette.success)
                    }
                }

                Spacer()

                Text(product.displayPrice)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(AppPalette.textPrimary(for: themeManager.current))
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppPalette.bgCard(for: themeManager.current))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(isSelected ? AppPalette.brand : .primary.opacity(0.06),
                                          lineWidth: isSelected ? 2 : 1)
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - CTA + 副信息

    private var ctaSection: some View {
        VStack(spacing: 10) {
            Button {
                Task { await purchaseSelected() }
            } label: {
                HStack {
                    if store.isLoading {
                        ProgressView().tint(.white)
                    }
                    Text(ctaTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Capsule().fill(AppPalette.brandGradient))
                .shadow(color: AppPalette.brand.opacity(0.4), radius: 14, x: 0, y: 8)
            }
            .buttonStyle(.plain)
            .disabled(selectedID == nil || store.isLoading)

            if let pid = selectedID.flatMap(StoreProductID.init(rawValue:)) {
                Text(lm.t(pid.isSubscription ? "可随时在 App Store 取消" : "一次购买，永久使用"))
                    .font(.system(size: 11))
                    .foregroundStyle(AppPalette.textTertiary(for: themeManager.current))
            }
        }
    }

    /// 主按钮文案：试用期 vs 直接购买
    private var ctaTitle: String {
        guard let pid = selectedID.flatMap(StoreProductID.init(rawValue:)) else {
            return lm.t("立即解锁")
        }
        if pid.isSubscription,
           let product = sortedProducts.first(where: { $0.id == pid.rawValue }),
           eligibleTrialProductIDs.contains(product.id),
           let days = product.freeTrialDays {
            return String(format: lm.t("免费试用 %d 天"), days)
        }
        return lm.t("立即解锁")
    }

    // MARK: - 恢复购买 + 兑换码 + 协议

    private var legalAndRestore: some View {
        VStack(spacing: 14) {
            HStack(spacing: 18) {
                Button(action: restorePurchases) {
                    Text(lm.t("已经购买?"))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AppPalette.brand)
                }
                Text("·").foregroundStyle(AppPalette.textTertiary(for: themeManager.current))
                Button {
                    showRedeemSheet = true
                } label: {
                    Text(lm.t("使用兑换码"))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AppPalette.brand)
                }
            }

            Text(lm.t("付款将在确认后从你的 Apple ID 账户中扣款；订阅会自动续订，可在 App Store 账户中随时取消。"))
                .font(.system(size: 11))
                .foregroundStyle(AppPalette.textTertiary(for: themeManager.current))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 6)

            HStack(spacing: 18) {
                Link(lm.t("隐私政策"),
                     destination: URL(string: "https://github.com/ZanwingMak/PhotoCleaner-OpenSource#privacy")
                        ?? URL(fileURLWithPath: "/"))
                Text("·")
                Link(lm.t("使用条款"),
                     destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")
                        ?? URL(fileURLWithPath: "/"))
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(AppPalette.brand)
        }
    }

    // MARK: - 行为

    private func purchaseSelected() async {
        guard let pid = selectedID,
              let product = sortedProducts.first(where: { $0.id == pid }) else { return }
        let ok = await store.purchase(product)
        if ok {
            dismissWithSuccess()
        } else if let msg = store.lastErrorMessage {
            toast = ToastInfo(symbol: "exclamationmark.triangle.fill",
                              text: msg,
                              tint: .red)
            store.lastErrorMessage = nil
        }
    }

    /// 查询当前 Apple ID 是否仍具备订阅组免费试用资格，避免展示不可用优惠
    private func refreshTrialEligibility() async {
        var eligible = Set<String>()
        for product in sortedProducts where product.hasFreeTrial {
            guard let subscription = product.subscription else { continue }
            if await subscription.isEligibleForIntroOffer {
                eligible.insert(product.id)
            }
        }
        eligibleTrialProductIDs = eligible
    }

    private func restorePurchases() {
        Task {
            let ok = await store.restore()
            if ok {
                toast = ToastInfo(symbol: "checkmark.circle.fill",
                                  text: lm.t("已恢复会员权益"),
                                  tint: AppPalette.success)
            } else {
                let message = store.lastErrorMessage ?? lm.t("未找到可恢复的购买记录")
                toast = ToastInfo(symbol: "info.circle.fill",
                                  text: message,
                                  tint: AppPalette.textSecondary(for: themeManager.current))
                store.lastErrorMessage = nil
            }
        }
    }

    private func dismissWithSuccess() {
        AppHaptics.notify(.success)
        dismiss()
    }
}

/// 触发付费墙的来源（用于副标提示）
enum PaywallReason {
    case upgrade
    case pendingFull
    case dailyLimit
    case fullHistoryLocked
    case spacePriorityLocked
    case insightsLocked
    case themeLocked

    var subtitleKey: String {
        switch self {
        case .upgrade:             return "解锁无限整理与深度洞察"
        case .pendingFull:         return "免费版待删除列表上限 50 张，升级后无上限"
        case .dailyLimit:          return "已达今日 300 张免费上限，升级后无限审核"
        case .fullHistoryLocked:   return "升级后可回顾完整月份时间线"
        case .spacePriorityLocked: return "升级后优先清理最占空间的内容"
        case .insightsLocked:      return "升级后查看完整整理趋势"
        case .themeLocked:         return "焦糖暖与冷色调为会员专属主题"
        }
    }
}
