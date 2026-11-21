//
//  SwipeReviewViewModel.swift
//  滑动审核视图的状态机：前后翻页（左/右滑）+ 上滑加入待删除
//

import Foundation
import Photos
import SwiftUI

/// 用户对当前卡片的处置：导航或标记
enum SwipeAction: Hashable {
    case next       // 右滑：进到下一张
    case previous   // 左滑：退到前一张
    case markDelete // 上滑：加入待删除并前进
}

/// 历史记录（只记录 markDelete，用于撤销；prev/next 无需记录因为可直接反向滑）
struct SwipeRecord: Hashable {
    let asset: PHAsset
    let fromIndex: Int
}

@MainActor
final class SwipeReviewViewModel: ObservableObject {

    @Published private(set) var assets: [PHAsset]
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var pendingDeletion: [PHAsset] = []
    @Published private(set) var deleteHistory: [SwipeRecord] = []
    /// 当前会话加载的实际可见照片数
    @Published var sessionLoadedCount: Int = 0
    /// 当前会话原始可加载照片数
    @Published var sessionTotalCount: Int = 0
    /// 当前会话已经做出保留或删除决定的照片数
    @Published private(set) var sessionReviewedCount: Int = 0

    private var reviewedAssetIDs = Set<String>()
    private var pendingAssetIDs = Set<String>()
    @Published private(set) var draftSaveFailed = false
    private var draftCategoryID: String?
    private var draftSort = "newest"
    private var saveTask: Task<Void, Never>?

    /// 是否已记录当前照片，回看时不再重复累计整理统计。
    var isCurrentReviewed: Bool {
        currentAsset.map { reviewedAssetIDs.contains($0.localIdentifier) } ?? false
    }

    /// 恢复仍获授权的资产标识，并保留当前队列的导航位置。
    func restore(_ draft: ReviewDraft?, categoryID: String, sort: String) {
        draftCategoryID = categoryID
        draftSort = sort
        guard let draft else { return }
        let available = Set(assets.map(\.localIdentifier))
        reviewedAssetIDs = draft.reviewedIDs.intersection(available)
        sessionReviewedCount = reviewedAssetIDs.count
        let pending = Set(draft.pendingIDs)
        pendingDeletion = assets.filter { pending.contains($0.localIdentifier) }
        pendingAssetIDs = Set(pendingDeletion.map(\.localIdentifier))
        if let id = draft.currentID, let index = assets.firstIndex(where: { $0.localIdentifier == id }) {
            currentIndex = index
        } else {
            currentIndex = assets.firstIndex(where: { !reviewedAssetIDs.contains($0.localIdentifier) }) ?? assets.count
        }
    }

    /// 合并外部图库变化，不把正在审核的位置跳回第一张。
    func reconcile(with updated: [PHAsset]) {
        let currentID = currentAsset?.localIdentifier
        let completed = !hasMore
        let available = Set(updated.map(\.localIdentifier))
        let pending = Set(pendingDeletion.map(\.localIdentifier))
        assets = updated
        pendingDeletion = updated.filter { pending.contains($0.localIdentifier) }
        pendingAssetIDs = Set(pendingDeletion.map(\.localIdentifier))
        deleteHistory.removeAll { !available.contains($0.asset.localIdentifier) }
        reviewedAssetIDs.formIntersection(available)
        sessionReviewedCount = reviewedAssetIDs.count
        sessionLoadedCount = updated.count
        sessionTotalCount = updated.count
        if let id = currentID, let index = updated.firstIndex(where: { $0.localIdentifier == id }) {
            currentIndex = index
        } else {
            currentIndex = completed ? updated.count : min(currentIndex, updated.count)
        }
        scheduleSave()
    }

    /// 合并连续滑动的写入，在用户停顿后保存检查点。
    func scheduleSave() {
        saveTask?.cancel()
        saveTask = Task { [weak self] in
            do { try await Task.sleep(for: .milliseconds(400)) } catch { return }
            await self?.saveDraft()
        }
    }

    /// 在离开页面或退到后台时立即保存；照片内容不写入草稿。
    func saveDraft() async {
        guard let categoryID = draftCategoryID else { return }
        let draft = ReviewDraft(currentID: currentAsset?.localIdentifier,
                                pendingIDs: pendingDeletion.map(\.localIdentifier), reviewedIDs: reviewedAssetIDs,
                                sort: draftSort, randomIDs: categoryID == "quick-random" ? assets.map(\.localIdentifier) : nil)
        draftSaveFailed = !(await ReviewDraftStore.shared.save(draft, for: categoryID))
    }


    /// 是否还有当前可显示的照片
    var hasMore: Bool { currentIndex < assets.count }

    /// 当前照片
    var currentAsset: PHAsset? {
        guard hasMore else { return nil }
        return assets[currentIndex]
    }

    /// 是否可向前翻页
    var canGoPrevious: Bool { currentIndex > 0 }

    /// 是否可向后翻页
    var canGoNext: Bool { currentIndex < assets.count - 1 }

    /// 初始化一个空队列或现有审核会话。
    init(assets: [PHAsset]) {
        self.assets = assets
    }

    /// 处理一次滑动操作
    func handle(_ action: SwipeAction) {
        guard !assets.isEmpty else { return }
        defer { scheduleSave() }

        switch action {
        case .previous:
            guard canGoPrevious else { return }
            currentIndex -= 1

        case .next:
            guard hasMore, let asset = currentAsset else { return }
            markReviewed(asset)
            currentIndex = min(currentIndex + 1, assets.count)

        case .markDelete:
            guard hasMore else { return }
            let asset = assets[currentIndex]
            markReviewed(asset)
            if pendingAssetIDs.insert(asset.localIdentifier).inserted {
                deleteHistory.append(SwipeRecord(asset: asset, fromIndex: currentIndex))
                pendingDeletion.append(asset)
            }
            currentIndex = min(currentIndex + 1, assets.count)
        }
    }

    /// 为新分类重置会话状态
    func reset(with newAssets: [PHAsset]) {
        saveTask?.cancel()
        draftCategoryID = nil
        assets = newAssets
        currentIndex = 0
        pendingDeletion = []
        pendingAssetIDs.removeAll()
        deleteHistory = []
        reviewedAssetIDs.removeAll()
        sessionReviewedCount = 0
        sessionLoadedCount = newAssets.count
        sessionTotalCount = newAssets.count
    }

    /// 将资产计入本次已审核数量，同一张只统计一次
    private func markReviewed(_ asset: PHAsset) {
        if reviewedAssetIDs.insert(asset.localIdentifier).inserted {
            sessionReviewedCount = reviewedAssetIDs.count
        }
    }

    /// 撤销最近一次 markDelete
    func undoLastDelete() {
        guard let last = deleteHistory.popLast() else { return }
        currentIndex = assets.firstIndex(where: { $0.localIdentifier == last.asset.localIdentifier }) ?? min(last.fromIndex, assets.count)
        scheduleSave()
        if let removeIdx = pendingDeletion.firstIndex(where: { $0.localIdentifier == last.asset.localIdentifier }) {
            pendingDeletion.remove(at: removeIdx)
            pendingAssetIDs.remove(last.asset.localIdentifier)
        }
    }

    /// 主动放弃当前选择时同步清空撤销历史和查重集合。
    func discardPending() {
        pendingDeletion.removeAll()
        pendingAssetIDs.removeAll()
        deleteHistory.removeAll()
        scheduleSave()
    }

    /// 删除成功后同步队列，保持仍存在的当前照片位置。
    func removeDeleted(_ identifiers: Set<String>) {
        reconcile(with: assets.filter { !identifiers.contains($0.localIdentifier) })
    }
}
