//
//  TutorialView.swift
//  首次启动与设置页共用的产品使用教程
//

import SwiftUI

struct TutorialView: View {
    @EnvironmentObject private var lm: LanguageManager
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let onFinish: () -> Void

    @State private var selectedPage = 0

    private var pages: [TutorialPage] {
        [
            TutorialPage(
                symbol: "hand.raised.fill",
                colors: [.blue, .cyan],
                title: lm.t("私密且安心"),
                message: lm.t("所有照片分析都在设备上完成，不会上传你的照片库。")
            ),
            TutorialPage(
                symbol: "rectangle.grid.2x2.fill",
                colors: [.purple, .pink],
                title: lm.t("选择整理入口"),
                message: lm.t("从智能建议、照片分类或时间线开始审核。")
            ),
            TutorialPage(
                symbol: "hand.draw.fill",
                colors: [.orange, .red],
                title: lm.t("简单滑动即可整理"),
                message: lm.t("左右滑动浏览，上滑把照片加入待删除列表。")
            ),
            TutorialPage(
                symbol: "checkmark.shield.fill",
                colors: [.green, .teal],
                title: lm.t("确认后才会删除"),
                message: lm.t("先检查待删除列表，再通过系统照片确认完成删除。")
            )
        ]
    }

    private var isLastPage: Bool {
        selectedPage == pages.count - 1
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppPalette.bgPrimary(for: themeManager.current),
                    AppPalette.brand.opacity(0.12),
                    AppPalette.bgPrimary(for: themeManager.current)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                TabView(selection: $selectedPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        tutorialPage(page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                footer
            }
        }
    }

    private var header: some View {
        HStack {
            Text("RollKeep")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(AppPalette.textPrimary(for: themeManager.current))
            Spacer()
            if !isLastPage {
                Button(lm.t("跳过")) {
                    onFinish()
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
                .frame(minWidth: 44, minHeight: 44)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }

    /// 构建单页教程内容，保持各步骤的布局与无障碍阅读顺序一致。
    private func tutorialPage(_ page: TutorialPage) -> some View {
        VStack(spacing: 28) {
            Spacer(minLength: 24)

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: page.colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 168, height: 168)
                    .shadow(color: page.colors[0].opacity(0.28), radius: 28, y: 16)

                Image(systemName: page.symbol)
                    .font(.system(size: 68, weight: .semibold))
                    .foregroundStyle(.white)
                    .accessibilityHidden(true)
            }

            VStack(spacing: 14) {
                Text(page.title)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(AppPalette.textPrimary(for: themeManager.current))
                    .multilineTextAlignment(.center)

                Text(page.message)
                    .font(.body)
                    .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
            }

            Spacer(minLength: 24)
        }
        .padding(.horizontal, 24)
    }

    private var footer: some View {
        VStack(spacing: 24) {
            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { index in
                    Capsule()
                        .fill(index == selectedPage ? AppPalette.brand : Color.secondary.opacity(0.25))
                        .frame(width: index == selectedPage ? 24 : 8, height: 8)
                        .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: selectedPage)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(selectedPage + 1) / \(pages.count)")

            Button {
                advanceOrFinish()
            } label: {
                HStack(spacing: 8) {
                    Text(lm.t(isLastPage ? "开始整理" : "下一步"))
                    Image(systemName: isLastPage ? "sparkles" : "arrow.forward")
                        .accessibilityHidden(true)
                }
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(AppPalette.brandGradient, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 28)
    }

    /// 推进到下一页，最后一页完成教程并交由调用方关闭。
    private func advanceOrFinish() {
        AppHaptics.impact(.soft)
        guard !isLastPage else {
            onFinish()
            return
        }
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.25)) {
            selectedPage += 1
        }
    }
}

private struct TutorialPage {
    let symbol: String
    let colors: [Color]
    let title: String
    let message: String
}
