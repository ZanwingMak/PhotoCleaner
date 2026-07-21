//
//  StoreService.swift
//  内购：月/年自动续订订阅 + 终身买断
//  使用 StoreKit 2 的 Transaction.currentEntitlements 作为权益真源
//

import Foundation
import StoreKit

/// App Store 产品标识枚举
/// 3 个产品需要在 App Store Connect 内购后台预先创建，标识必须完全一致
enum StoreProductID: String, CaseIterable, Identifiable {
    case monthly   = "app.rollkeep.RollKeep.sub.monthly"
    case yearly    = "app.rollkeep.RollKeep.sub.yearly"
    case lifetime  = "app.rollkeep.RollKeep.lifetime"

    var id: String { rawValue }

    /// 中文 title key（通过 lm.t 转译为多语言）
    var titleKey: String {
        switch self {
        case .monthly:   return "月订阅"
        case .yearly:    return "年订阅"
        case .lifetime:  return "终身版"
        }
    }

    /// 副标 key（订阅周期描述）
    var periodKey: String {
        switch self {
        case .monthly:   return "每月续订"
        case .yearly:    return "每年续订"
        case .lifetime:  return "一次买断，永久使用"
        }
    }

    /// 是否为订阅类
    var isSubscription: Bool { self != .lifetime }

    /// UI 排序权重（年订阅默认最划算放最显眼）
    var sortOrder: Int {
        switch self {
        case .yearly:    return 0
        case .lifetime:  return 1
        case .monthly:   return 2
        }
    }
}

/// 应用全局内购服务
@MainActor
final class StoreService: ObservableObject {

    /// 已从 App Store 加载到的商品对象
    @Published private(set) var products: [Product] = []
    /// 当前有效的产品 ID 集合（订阅未过期 + 终身买断）
    @Published private(set) var purchasedProductIDs: Set<String> = []
    /// 是否正在拉取商品或处理交易
    @Published private(set) var isLoading: Bool = false
    /// 最近一次失败信息（供 UI 提示）
    @Published var lastErrorMessage: String?

    private var updatesTask: Task<Void, Never>?

    /// 是否解锁付费版（任意一档有效即解锁）
    var isPro: Bool { !purchasedProductIDs.isEmpty }

    init() {
        // 启动后立即根据 currentEntitlements 解析当前权益，并挂上交易监听
        updatesTask = Task { [weak self] in await self?.listenForTransactions() }
        Task { [weak self] in await self?.refreshEntitlements() }
    }

    deinit {
        updatesTask?.cancel()
    }

    /// 从 App Store 拉取产品定义；失败不抛错，仅记录到 lastErrorMessage
    func loadProducts() async {
        lastErrorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            let ids = StoreProductID.allCases.map(\.rawValue)
            let fetched = try await Product.products(for: ids)
            products = fetched.sorted { lhsSort($0) < lhsSort($1) }
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    /// 按枚举顺序权重排
    private func lhsSort(_ p: Product) -> Int {
        StoreProductID(rawValue: p.id)?.sortOrder ?? 99
    }

    /// 发起购买；返回是否最终解锁了权益
    @discardableResult
    func purchase(_ product: Product) async -> Bool {
        lastErrorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await refreshEntitlements()
                return isPro
            case .userCancelled:
                return false
            case .pending:
                // 家庭共享/家长审批等场景，等 Transaction.updates 异步推送
                return false
            @unknown default:
                return false
            }
        } catch {
            lastErrorMessage = error.localizedDescription
            return false
        }
    }

    /// 恢复购买：触发 AppStore.sync 后再次解析权益
    func restore() async -> Bool {
        lastErrorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            try await AppStore.sync()
            await refreshEntitlements()
            return isPro
        } catch {
            lastErrorMessage = error.localizedDescription
            return false
        }
    }

    /// 重新扫一遍当前所有有效权益（订阅未过期 + 终身买断）
    func refreshEntitlements() async {
        var owned = Set<String>()
        let knownProductIDs = Set(StoreProductID.allCases.map(\.rawValue))
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }
            // 显式撤销/退款的不算
            if transaction.revocationDate != nil { continue }
            // 订阅到期的不算
            if let exp = transaction.expirationDate, exp < Date() { continue }
            if knownProductIDs.contains(transaction.productID) {
                owned.insert(transaction.productID)
            }
        }
        purchasedProductIDs = owned
    }

    /// 后台监听交易事件（续订成功、家长批准、退款等）
    private func listenForTransactions() async {
        for await result in Transaction.updates {
            guard case .verified(let transaction) = result else { continue }
            await transaction.finish()
            await refreshEntitlements()
        }
    }

    /// 校验 VerificationResult；未通过签名时抛错
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error): throw error
        case .verified(let value):      return value
        }
    }
}

// MARK: - 价格 / 试用期 UI 辅助

extension Product {
    /// 是否带免费引导期（在 App Store Connect 配置 introductoryOffer 为 freeTrial）
    var hasFreeTrial: Bool {
        guard let intro = subscription?.introductoryOffer else { return false }
        return intro.paymentMode == .freeTrial
    }

    /// 引导期天数（仅用于展示，"3 天免费"）
    var freeTrialDays: Int? {
        guard let intro = subscription?.introductoryOffer,
              intro.paymentMode == .freeTrial else { return nil }
        let unit = intro.period.unit
        let value = intro.period.value
        switch unit {
        case .day:   return value
        case .week:  return value * 7
        case .month: return value * 30
        case .year:  return value * 365
        @unknown default: return value
        }
    }
}
