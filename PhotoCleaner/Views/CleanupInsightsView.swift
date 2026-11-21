//
//  CleanupInsightsView.swift
//  本地整理洞察：累计成果、连续天数与最近 7 天趋势
//

import SwiftUI

struct CleanupInsightsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var usage: UsageTracker
    @EnvironmentObject private var lm: LanguageManager
    @EnvironmentObject private var themeManager: ThemeManager

    private var recentStats: [CleanupDayStat] { usage.recentStats(dayCount: 7) }
    private var recentMaximum: Int { max(1, recentStats.map(\.reviewedCount).max() ?? 1) }

    var body: some View {
        NavigationStack {
            ZStack {
                AppPalette.bgPrimary(for: themeManager.current).ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        achievementHero
                        metricGrid
                        weeklyTrend
                        privacyNote
                        Color.clear.frame(height: 24)
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: 720)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
                }
            }
            .preferredColorScheme(themeManager.current.colorScheme)
            .navigationTitle(lm.t("整理洞察"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(lm.t("关闭")) { dismiss() }
                        .tint(AppPalette.brand)
                }
            }
        }
    }

    private var achievementHero: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppPalette.brandGradient)
                    .frame(width: 82, height: 82)
                Image(systemName: "sparkles")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
            }
            .shadow(color: AppPalette.brand.opacity(0.35), radius: 18, x: 0, y: 10)

            Text(formattedBytes(usage.totalFreedBytes))
                .font(.system(size: 36, weight: .heavy, design: .rounded))
                .foregroundStyle(AppPalette.textPrimary(for: themeManager.current))
            Text(lm.t("累计释放空间"))
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppPalette.bgCardElevated(for: themeManager.current))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(AppPalette.brand.opacity(0.18), lineWidth: 1)
                )
        )
    }

    private var metricGrid: some View {
        HStack(spacing: 10) {
            metricTile(value: "\(usage.totalReviewedCount)",
                       label: lm.t("已审核"),
                       symbol: "checkmark.circle.fill",
                       tint: .blue)
            metricTile(value: "\(usage.totalDeletedCount)",
                       label: lm.t("已清理"),
                       symbol: "trash.circle.fill",
                       tint: .red)
            metricTile(value: "\(usage.currentStreak)",
                       label: lm.t("连续天数"),
                       symbol: "flame.fill",
                       tint: .orange)
        }
    }

    private var weeklyTrend: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 3) {
                Text(lm.t("最近 7 天"))
                    .font(.headline)
                    .foregroundStyle(AppPalette.textPrimary(for: themeManager.current))
                Text(lm.t("每天审核的照片数量"))
                    .font(.caption)
                    .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
            }

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(recentStats) { stat in
                    trendBar(stat)
                }
            }
            .frame(height: 142, alignment: .bottom)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppPalette.bgCard(for: themeManager.current))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(.primary.opacity(0.05), lineWidth: 1)
                )
        )
    }

    private var privacyNote: some View {
        Label(lm.t("整理统计仅保存在这台设备上"), systemImage: "lock.shield.fill")
            .font(.footnote.weight(.medium))
            .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppPalette.brand.opacity(0.1))
            )
    }

    /// 构建单个累计指标卡片
    private func metricTile(value: String, label: String, symbol: String, tint: Color) -> some View {
        VStack(spacing: 7) {
            Image(systemName: symbol)
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(tint)
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(AppPalette.textPrimary(for: themeManager.current))
            Text(label)
                .font(.caption)
                .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppPalette.bgCard(for: themeManager.current))
        )
        .accessibilityElement(children: .combine)
    }

    /// 构建单日趋势柱并提供完整无障碍描述
    private func trendBar(_ stat: CleanupDayStat) -> some View {
        let ratio = Double(stat.reviewedCount) / Double(recentMaximum)
        return VStack(spacing: 6) {
            Text("\(stat.reviewedCount)")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(AppPalette.textSecondary(for: themeManager.current))
                .opacity(stat.reviewedCount == 0 ? 0 : 1)
            Capsule()
                .fill(stat.reviewedCount > 0 ? AppPalette.brandGradient :
                        LinearGradient(colors: [Color.primary.opacity(0.08)],
                                       startPoint: .top,
                                       endPoint: .bottom))
                .frame(height: max(6, 92 * ratio))
            Text(weekdayLabel(for: stat.dayKey))
                .font(.caption2.weight(.medium))
                .foregroundStyle(AppPalette.textTertiary(for: themeManager.current))
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(weekdayLabel(for: stat.dayKey))，\(stat.reviewedCount) \(lm.t("张"))")
    }

    /// 把日期键转换为当前语言的短星期名
    private func weekdayLabel(for dayKey: String) -> String {
        let parser = DateFormatter()
        parser.locale = Locale(identifier: "en_US_POSIX")
        parser.dateFormat = "yyyy-MM-dd"
        guard let date = parser.date(from: dayKey) else { return "—" }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: lm.effective.localeIdentifier)
        formatter.setLocalizedDateFormatFromTemplate("EEE")
        return formatter.string(from: date)
    }

    /// 使用系统本地化规则格式化释放空间
    private func formattedBytes(_ bytes: Int64) -> String {
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
    }
}
