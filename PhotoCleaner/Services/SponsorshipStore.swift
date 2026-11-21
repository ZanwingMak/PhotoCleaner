import Foundation
import StoreKit

/// 可重复购买的一次性赞助，不关联功能权限或会员等级。
enum SponsorshipProduct: String, CaseIterable {
    case thanks = "app.rollkeep.RollKeep.support.099"
    case coffee = "app.rollkeep.RollKeep.support.199"
    case dessert = "app.rollkeep.RollKeep.support.299"
    case support = "app.rollkeep.RollKeep.support.599"
    case gratitude = "app.rollkeep.RollKeep.support.999"

    /// 按五个美元基准金额的顺序展示，实际价格由 App Store 提供。
    var order: Int { Self.allCases.firstIndex(of: self) ?? 0 }
}

/// 只负责自愿赞助交易；照片整理功能不依赖此对象的任何状态。
@MainActor
final class SponsorshipStore: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isPurchasing = false
    @Published private(set) var message: String?
    private var updatesTask: Task<Void, Never>?

    /// 停止长期交易监听，释放购买状态对象。
    deinit { updatesTask?.cancel() }

    /// 监听延后批准的交易并补完中断的交易，启动时不加载商品。
    func start() async {
        guard updatesTask == nil else { return }
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                await self.finish(result)
            }
        }
        for await result in Transaction.unfinished {
            await finish(result)
        }
    }

    /// 进入赞助页时加载真实消耗型商品；失败时允许重新加载。
    func loadProducts() async {
        guard !isLoading, products.isEmpty else { return }
        isLoading = true
        message = nil
        defer { isLoading = false }
        do {
            products = try await Product.products(for: SponsorshipProduct.allCases.map(\.rawValue))
                .filter { $0.type == .consumable }
                .sorted {
                    (SponsorshipProduct(rawValue: $0.id)?.order ?? .max)
                        < (SponsorshipProduct(rawValue: $1.id)?.order ?? .max)
                }
            if products.isEmpty { message = "暂时无法加载赞助项目，请稍后重试。" }
        } catch {
            message = "暂时无法加载赞助项目，请稍后重试。"
        }
    }

    /// 执行单次赞助；只完成通过 Apple 签名校验的已知消耗型交易。
    func purchase(_ product: Product) async -> Bool {
        guard !isPurchasing, product.type == .consumable,
              SponsorshipProduct(rawValue: product.id) != nil else { return false }
        isPurchasing = true
        message = nil
        defer { isPurchasing = false }
        do {
            switch try await product.purchase() {
            case .success(let result):
                guard case .verified(let transaction) = result,
                      transaction.productID == product.id else {
                    message = "无法验证本次赞助，请联系 Apple 支持。"
                    return false
                }
                return await finish(result)
            case .userCancelled:
                return false
            case .pending:
                message = "赞助正在等待 Apple 批准。"
                return false
            @unknown default:
                message = "赞助未完成，请稍后重试。"
                return false
            }
        } catch {
            message = "赞助未完成，请稍后重试。"
            return false
        }
    }

    /// 完成可验证的赞助交易；被撤销的交易不会显示成功提示。
    @discardableResult
    private func finish(_ result: VerificationResult<Transaction>) async -> Bool {
        guard case .verified(let transaction) = result,
              transaction.productType == .consumable,
              SponsorshipProduct(rawValue: transaction.productID) != nil else { return false }
        await transaction.finish()
        guard transaction.revocationDate == nil else { return false }
        message = "感谢你的赞助与支持！"
        return true
    }
}
