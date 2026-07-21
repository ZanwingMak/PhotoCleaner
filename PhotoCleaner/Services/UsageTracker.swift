//
//  UsageTracker.swift
//  免费版限额 + 本地整理统计
//  Pro 用户全部无限；Free 用户在以下任一规则触发时弹付费墙
//

import Foundation
import SwiftUI

/// 集中维护免费版上限常量
enum FreeLimits {
    /// 待删除列表同时持有的最大照片数
    static let pendingMax = 50
    /// 每天可"审核"的最大张数（任何一次有效滑动均计入）
    static let dailyReviewMax = 300
}

/// 单日整理统计，仅保存在本机
struct CleanupDayStat: Codable, Identifiable, Sendable {
    let dayKey: String
    var reviewedCount: Int
    var deletedCount: Int
    var freedBytes: Int64

    var id: String { dayKey }
}

/// 跟踪每日审核数量；按当天日期 key 持久化，跨日自动归零
@MainActor
final class UsageTracker: ObservableObject {

    @Published private(set) var todayReviewedCount: Int = 0
    @Published private(set) var dailyStats: [CleanupDayStat] = []

    /// 当前生效的"今日" key（yyyy-MM-dd）
    private var todayKey: String { Self.dateKey(for: Date()) }

    /// 上次写入时的日期 key（用于跨日检测）
    @AppStorage("usage_last_day_key") private var lastDayKey: String = ""
    /// 持久化的当日计数
    @AppStorage("usage_today_count") private var storedCount: Int = 0
    /// 最近 90 天整理统计的 JSON 数据
    @AppStorage("cleanup_daily_stats_v1") private var statsData: Data = Data()

    /// 累计审核张数
    var totalReviewedCount: Int { dailyStats.reduce(0) { $0 + $1.reviewedCount } }
    /// 累计删除张数
    var totalDeletedCount: Int { dailyStats.reduce(0) { $0 + $1.deletedCount } }
    /// 累计释放字节数
    var totalFreedBytes: Int64 { dailyStats.reduce(0) { $0 + $1.freedBytes } }
    /// 有整理行为的总天数
    var activeDayCount: Int {
        dailyStats.filter { $0.reviewedCount > 0 || $0.deletedCount > 0 }.count
    }
    /// 当前连续整理天数；今天尚未整理时允许从昨天延续
    var currentStreak: Int { calculateCurrentStreak() }

    init() {
        loadStats()
        rolloverIfNeeded()
        todayReviewedCount = storedCount
        migrateTodayCountIfNeeded()
    }

    /// 是否还能继续审核（Pro 永远 true）
    func canReviewMore(isPro: Bool) -> Bool {
        if isPro { return true }
        rolloverIfNeeded()
        return storedCount < FreeLimits.dailyReviewMax
    }

    /// 记录一次审核（任一方向的滑动）；返回是否仍在允许范围内
    @discardableResult
    func recordReview(isPro: Bool) -> Bool {
        rolloverIfNeeded()
        if !isPro {
            storedCount += 1
            todayReviewedCount = storedCount
        }
        updateTodayStat { stat in
            stat.reviewedCount += 1
        }
        return isPro || storedCount <= FreeLimits.dailyReviewMax
    }

    /// 记录一次确认删除及实际释放空间
    func recordDeletion(count: Int, freedBytes: Int64) {
        guard count > 0 else { return }
        updateTodayStat { stat in
            stat.deletedCount += count
            stat.freedBytes += max(0, freedBytes)
        }
    }

    /// 今日剩余可审核数（仅用于 UI 展示）
    func remainingToday(isPro: Bool) -> Int {
        if isPro { return Int.max }
        rolloverIfNeeded()
        return max(0, FreeLimits.dailyReviewMax - storedCount)
    }

    /// 跨日时把计数归零
    private func rolloverIfNeeded() {
        if lastDayKey != todayKey {
            lastDayKey = todayKey
            storedCount = 0
            todayReviewedCount = 0
        }
    }

    /// 返回包含空白日期的最近若干天统计，供趋势图稳定展示
    func recentStats(dayCount: Int) -> [CleanupDayStat] {
        guard dayCount > 0 else { return [] }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lookup = Dictionary(uniqueKeysWithValues: dailyStats.map { ($0.dayKey, $0) })

        return (0..<dayCount).reversed().compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            let key = Self.dateKey(for: date)
            return lookup[key] ?? CleanupDayStat(
                dayKey: key,
                reviewedCount: 0,
                deletedCount: 0,
                freedBytes: 0
            )
        }
    }

    /// 从持久化数据恢复整理统计
    private func loadStats() {
        guard !statsData.isEmpty,
              let decoded = try? JSONDecoder().decode([CleanupDayStat].self, from: statsData)
        else { return }
        dailyStats = decoded.sorted { $0.dayKey < $1.dayKey }
    }

    /// 将旧版当日计数补入趋势数据，避免升级后统计归零
    private func migrateTodayCountIfNeeded() {
        guard storedCount > 0,
              !dailyStats.contains(where: { $0.dayKey == todayKey })
        else { return }
        updateTodayStat { stat in
            stat.reviewedCount = storedCount
        }
    }

    /// 更新今天的统计记录并持久化
    private func updateTodayStat(_ mutate: (inout CleanupDayStat) -> Void) {
        let key = todayKey
        if let index = dailyStats.firstIndex(where: { $0.dayKey == key }) {
            mutate(&dailyStats[index])
        } else {
            var stat = CleanupDayStat(dayKey: key, reviewedCount: 0, deletedCount: 0, freedBytes: 0)
            mutate(&stat)
            dailyStats.append(stat)
        }
        dailyStats.sort { $0.dayKey < $1.dayKey }
        if dailyStats.count > 90 {
            dailyStats.removeFirst(dailyStats.count - 90)
        }
        persistStats()
        objectWillChange.send()
    }

    /// 把最近统计编码到 UserDefaults
    private func persistStats() {
        guard let data = try? JSONEncoder().encode(dailyStats) else { return }
        statsData = data
    }

    /// 计算从今天或昨天开始的连续活跃天数
    private func calculateCurrentStreak() -> Int {
        let activeKeys = Set(
            dailyStats
                .filter { $0.reviewedCount > 0 || $0.deletedCount > 0 }
                .map(\.dayKey)
        )
        let calendar = Calendar.current
        var cursor = calendar.startOfDay(for: Date())
        if !activeKeys.contains(Self.dateKey(for: cursor)),
           let yesterday = calendar.date(byAdding: .day, value: -1, to: cursor) {
            cursor = yesterday
        }

        var streak = 0
        while activeKeys.contains(Self.dateKey(for: cursor)) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }
        return streak
    }

    /// yyyy-MM-dd 日期 key
    private static func dateKey(for date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }
}
