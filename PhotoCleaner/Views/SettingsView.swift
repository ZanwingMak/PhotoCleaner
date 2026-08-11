//
//  SettingsView.swift
//  设置面板：会员状态 + 偏好开关 + 主题切换 + 关于
//

import SwiftUI
import Photos
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.systemColorScheme) private var systemScheme  // App root 注入：系统真实模式，不被任何 override 污染
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject private var library: PhotoLibraryService
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var lm: LanguageManager
    @EnvironmentObject private var store: StoreService
    @EnvironmentObject private var usage: UsageTracker

    @AppStorage("haptics_enabled")        private var hapticsEnabled = true
    @AppStorage("thumbnail_hq")           private var hqThumbnails = true
    @AppStorage("confirm_before_delete")  private var confirmBeforeDelete = true

    @State private var isScanning = false
    @State private var toast: ToastInfo?
    @State private var showPaywall = false
    @State private var paywallReason: PaywallReason = .upgrade

    /// 上架前分享公开项目页，上架后可替换为 App Store 商品页
    private let appStoreURL = URL(string: "https://github.com/ZanwingMak/PhotoCleaner-OpenSource")
        ?? URL(fileURLWithPath: "/")

    var body: some View {
        NavigationStack {
            ZStack {
                AppPalette.bgPrimary(for: themeManager.current).ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        brandHeader

                        membershipSection

                        section(lm.t("外观")) {
                            themePickerRow
                        }

                        section(lm.t("语言")) {
                            languagePickerRow
                        }

                        section(lm.t("浏览体验")) {
                            toggleRow(label: lm.t("触觉反馈"), symbol: "iphone.gen2.radiowaves.left.and.right",
                                       binding: $hapticsEnabled)
                            divider
                            toggleRow(label: lm.t("高清缩略图"), symbol: "rectangle.stack",
                                       binding: $hqThumbnails)
                            divider
                            toggleRow(label: lm.t("删除前二次确认"), symbol: "checkmark.shield",
                                       binding: $confirmBeforeDelete)
                        }

                        section(lm.t("数据")) {
                            infoRow(label: lm.t("已扫描照片"), symbol: "photo.on.rectangle",
                                     value: "\(library.categoryCounts[PhotoCategory.allPhotos.id] ?? 0)")
                            if !store.isPro {
                                divider
                                infoRow(label: lm.t("今日剩余可整理"), symbol: "gauge.with.dots.needle.50percent",
                                         value: "\(usage.remainingToday(isPro: false))")
                            }
                            divider
                            scanRow
                        }

                        section(lm.t("支持我们")) {
                            actionRow(label: lm.t("给个好评"), symbol: "star.fill", tint: .yellow) {
                                requestReview()
                            }
                            divider
                            shareRow
                        }

                        section(lm.t("账户")) {
                            actionRow(label: lm.t("已经购买?"), symbol: "arrow.clockwise.circle.fill", tint: AppPalette.brand) {
                                Task { await performRestore() }
                            }
                            divider
                            linkRow(label: lm.t("管理订阅"), symbol: "creditcard.fill",
                                     url: "https://apps.apple.com/account/subscriptions")
                        }

                        section(lm.t("关于")) {
                            infoRow(label: lm.t("版本"), symbol: "info.circle", value: appVersion)
                            divider
                            linkRow(label: lm.t("隐私政策"), symbol: "hand.raised.fill",
                                     url: "https://github.com/ZanwingMak/PhotoCleaner-OpenSource#privacy")
                            divider
                            linkRow(label: lm.t("使用条款 (EULA)"), symbol: "doc.text.fill",
                                     url: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")
                        }

                        footerNote
                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
            .toast($toast)
            .sheet(isPresented: $showPaywall) {
                PaywallView(reason: paywallReason)
            }
            .preferredColorScheme(preferredSchemeForSheet)
            .navigationTitle(lm.t("设置"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(lm.t("关闭")) {
                        dismiss()
                    }
                    .tint(AppPalette.brand)
                }
            }
        }
        // 主题变化时让整个 NavigationStack 重建，绕过 sheet 内 traitCollection 缓存
        .id(themeManager.current.rawValue)
    }

    // MARK: - 会员卡片

    private var membershipSection: some View {
        Button {
            AppHaptics.impact(.soft)
            if !store.isPro {
                paywallReason = .upgrade
                showPaywall = true
            }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AppPalette.brandGradient)
                        .frame(width: 52, height: 52)
                    Image(systemName: store.isPro ? "crown.fill" : "sparkles")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.isPro ? lm.t("RollKeep 会员") : lm.t("升级会员"))
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(AppPalette.textPrimary(for: themeManager.current))
                    Text(store.isPro ? lm.t("已解锁全部功能") : lm.t("解锁无限整理与深度洞察"))
                        .font(.system(size: 12))
                        .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
                }
                Spacer()
                if !store.isPro {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AppPalette.textTertiary(for: themeManager.current))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppPalette.bgCard(for: themeManager.current))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(AppPalette.brand.opacity(store.isPro ? 0.5 : 0.18), lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(store.isPro)
    }

    /// 分享行：把 App Store 链接通过系统分享面板送出
    private var shareRow: some View {
        ShareLink(item: appStoreURL,
                  subject: Text(lm.t("RollKeep")),
                  message: Text(lm.t("用 RollKeep 整理你的照片库，腾出更多空间。"))) {
            HStack(spacing: 14) {
                iconBubble("square.and.arrow.up", tint: .blue)
                Text(lm.t("分享给朋友"))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppPalette.textPrimary(for: theme))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(AppPalette.textTertiary(for: theme))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    /// 恢复购买并反馈
    private func performRestore() async {
        let ok = await store.restore()
        if ok {
            AppHaptics.notify(.success)
            toast = ToastInfo(symbol: "checkmark.circle.fill",
                              text: lm.t("已恢复会员权益"),
                              tint: AppPalette.success)
        } else {
            toast = ToastInfo(symbol: "info.circle.fill",
                              text: lm.t("未找到可恢复的购买记录"),
                              tint: AppPalette.textSecondary(for: theme))
        }
    }

    // MARK: - 语言选择行

    private var languagePickerRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                iconBubble("character.bubble", tint: AppPalette.brand)
                Text(lm.t("语言"))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppPalette.textPrimary(for: theme))
                Spacer()
                Text(lm.t(lm.current.title))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppPalette.textSecondary(for: theme))
            }

            // 横向 5 个语言按钮
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(AppLanguage.allCases) { lang in
                        Button {
                            AppHaptics.impact(.soft)
                            lm.set(lang)
                        } label: {
                            let isSelected = lm.current == lang
                            Text(lm.t(lang.title))
                                .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                .foregroundStyle(isSelected ? .white : AppPalette.textSecondary(for: theme))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background {
                                    if isSelected {
                                        Capsule().fill(AppPalette.brandGradient)
                                    } else {
                                        Capsule().fill(Color.primary.opacity(0.08))
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
    }

    /// 重新扫描分类按钮 — 含 loading + 完成 toast
    private var scanRow: some View {
        Button {
            Task { await rescanWithFeedback() }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AppPalette.brand.opacity(0.18))
                        .frame(width: 30, height: 30)
                    if isScanning {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(AppPalette.brand)
                            .scaleEffect(0.7)
                    } else {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(AppPalette.brand)
                    }
                }
                Text(isScanning ? lm.t("正在扫描…") : lm.t("重新扫描分类"))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppPalette.textPrimary(for: theme))
                Spacer()
                if !isScanning {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(AppPalette.textTertiary(for: theme))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isScanning)
    }

    /// 执行重新扫描 + 反馈
    private func rescanWithFeedback() async {
        AppHaptics.impact(.soft)
        isScanning = true
        await library.refreshCategoryCounts()
        isScanning = false
        AppHaptics.notify(.success)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            let count = library.categoryCounts[PhotoCategory.allPhotos.id] ?? 0
            toast = ToastInfo(
                symbol: "checkmark.circle.fill",
                text: String(format: lm.t("扫描完成 · %d 张"), count),
                tint: AppPalette.success
            )
        }
    }

    private var theme: AppTheme { themeManager.current }

    /// .system 主题在 sheet 内显式 resolve 为当前系统真实模式
    /// 用 App root 注入的 systemScheme（@Environment(\.colorScheme) 在 .preferredColorScheme 之前读到的值）
    /// 避免 nil 触发 UIHostingController.overrideUserInterfaceStyle 缓存导致的背景错位
    private var preferredSchemeForSheet: ColorScheme? {
        themeManager.current == .system ? systemScheme : themeManager.current.colorScheme
    }

    /// 从 Info.plist 读取当前 build 的版本号，避免硬编码
    private var appVersion: String {
        let short = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        if let s = short, let b = build, s != b {
            return "\(s) (\(b))"
        }
        return short ?? "—"
    }

    // MARK: - 顶部品牌头

    private var brandHeader: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(AppPalette.brandGradient)
                    .frame(width: 76, height: 76)
                Image(systemName: "rectangle.stack.fill")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
            }
            .shadow(color: AppPalette.brand.opacity(0.5), radius: 16, x: 0, y: 8)

            Text("RollKeep")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(AppPalette.textPrimary(for: theme))
            Text(lm.t("整理你的照片库，腾出存储空间"))
                .font(.system(size: 13))
                .foregroundStyle(AppPalette.textSecondary(for: theme))
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - 主题切换行（5 个色块横向，非 Pro 锁定）

    private var themePickerRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                iconBubble("paintbrush.fill", tint: AppPalette.brand)
                Text(lm.t("主题"))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppPalette.textPrimary(for: theme))
                Spacer()
                Text(lm.t(themeManager.current.title))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppPalette.textSecondary(for: theme))
            }

            HStack(spacing: 10) {
                ForEach(AppTheme.allCases) { t in
                    Button {
                        AppHaptics.impact(.soft)
                        if store.isPro || !t.isPremium {
                            themeManager.set(t)
                        } else {
                            paywallReason = .themeLocked
                            showPaywall = true
                        }
                    } label: {
                        themeSwatch(t)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
    }

    /// 单个主题色块；非 Pro 显示小锁
    private func themeSwatch(_ t: AppTheme) -> some View {
        let isSelected = themeManager.current == t
        let locked = !store.isPro && t.isPremium
        return VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(t.swatch)
                    .frame(height: 52)
                    .overlay {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(
                                isSelected ? AppPalette.brand : Color.primary.opacity(0.08),
                                lineWidth: isSelected ? 2.5 : 1
                            )
                    }
                Image(systemName: t.symbol)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(t == .light ? .black : .white)
                    .opacity(0.8)
                if locked && !isSelected {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(4)
                        .background(Circle().fill(.black.opacity(0.55)))
                        .offset(x: 16, y: 16)
                }
            }
            Text(lm.t(t.title))
                .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                .foregroundStyle(isSelected ? AppPalette.brand
                                            : AppPalette.textSecondary(for: theme))
                .lineLimit(1)
        }
    }

    // MARK: - 通用 section

    @ViewBuilder
    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppPalette.textSecondary(for: theme))
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppPalette.bgCard(for: theme))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(.primary.opacity(0.04), lineWidth: 1)
                    )
            )
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.05))
            .frame(height: 1)
            .padding(.leading, 50)
    }

    // MARK: - 行类型

    private func toggleRow(label: String, symbol: String, binding: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            iconBubble(symbol, tint: AppPalette.brand)
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AppPalette.textPrimary(for: theme))
            Spacer()
            Toggle("", isOn: binding)
                .labelsHidden()
                .tint(AppPalette.brand)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private func infoRow(label: String, symbol: String, value: String) -> some View {
        HStack(spacing: 14) {
            iconBubble(symbol, tint: AppPalette.textSecondary(for: theme))
            Text(label)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AppPalette.textPrimary(for: theme))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(AppPalette.textSecondary(for: theme))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    private func actionRow(label: String, symbol: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button {
            AppHaptics.impact(.soft)
            action()
        } label: {
            HStack(spacing: 14) {
                iconBubble(symbol, tint: tint)
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppPalette.textPrimary(for: theme))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(AppPalette.textTertiary(for: theme))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func linkRow(label: String, symbol: String, url: String) -> some View {
        Link(destination: URL(string: url) ?? URL(fileURLWithPath: "/")) {
            HStack(spacing: 14) {
                iconBubble(symbol, tint: AppPalette.brand)
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(AppPalette.textPrimary(for: theme))
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(AppPalette.textTertiary(for: theme))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
    }

    private func iconBubble(_ symbol: String, tint: Color) -> some View {
        ZStack {
            Circle()
                .fill(tint.opacity(0.18))
                .frame(width: 30, height: 30)
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(tint)
        }
    }

    private var footerNote: some View {
        VStack(spacing: 6) {
            Image(systemName: "lock.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(AppPalette.textTertiary(for: theme))
            Text(lm.t("RollKeep 在本地处理你的所有照片\n绝不上传任何数据"))
                .font(.system(size: 11))
                .foregroundStyle(AppPalette.textTertiary(for: theme))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 12)
    }
}
