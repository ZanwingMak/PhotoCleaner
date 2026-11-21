import Foundation

/// 仅在本机保存资产标识和审核进度，不保存照片内容。
struct ReviewDraft: Codable, Sendable {
    let currentID: String?
    let pendingIDs: [String]
    let reviewedIDs: Set<String>
    let sort: String
    let randomIDs: [String]?
}

/// 串行读写整理草稿，原子替换文件以应对应用中断。
actor ReviewDraftStore {
    static let shared = ReviewDraftStore()

    /// 从本地恢复指定分类最近的整理进度。
    func load(_ categoryID: String) -> ReviewDraft? {
        guard let url = location(categoryID), let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(ReviewDraft.self, from: data)
    }

    /// 写入审核检查点；文件只包含当前设备的 Photos 标识。
    func save(_ draft: ReviewDraft, for categoryID: String) -> Bool {
        guard let url = location(categoryID), let data = try? JSONEncoder().encode(draft) else { return false }
        do {
            try data.write(to: url, options: [.atomic, .completeFileProtectionUnlessOpen])
            return true
        } catch { return false }
    }

    /// 返回应用私有支持目录中的分类草稿路径。
    private func location(_ categoryID: String) -> URL? {
        guard categoryID.allSatisfy({ $0.isLetter || $0.isNumber || $0 == "-" }),
              let root = try? FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask,
                                                       appropriateFor: nil, create: true) else { return nil }
        let directory = root.appendingPathComponent("ReviewDrafts", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            var protectedDirectory = directory
            var values = URLResourceValues()
            values.isExcludedFromBackup = true
            try? protectedDirectory.setResourceValues(values)
            return directory.appendingPathComponent(categoryID + ".json")
        } catch { return nil }
    }
}
