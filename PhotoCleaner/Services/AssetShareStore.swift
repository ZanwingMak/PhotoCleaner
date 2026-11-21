import Foundation
import Photos

/// 分享文件在系统面板关闭前保留于临时目录。
struct SharedAssetFile: Identifiable {
    let id = UUID()
    let url: URL
}

/// 通过 Photos 导出实际媒体资源，视频分享保留视频格式而非封面图。
@MainActor
final class AssetShareStore: ObservableObject {
    @Published var item: SharedAssetFile?
    @Published private(set) var isLoading = false
    @Published private(set) var progress: Double = 0
    @Published var error: String?
    private var generation = UUID()
    private var directory: URL?

    /// 导出系统提供的当前全尺寸资源，并显示 iCloud 下载进度。
    func prepare(_ asset: PHAsset) {
        guard !isLoading else { return }
        cleanup()
        error = nil
        let resources = PHAssetResource.assetResources(for: asset)
        let preferred: [PHAssetResourceType] = asset.mediaType == .video ? [.fullSizeVideo, .video] : [.fullSizePhoto, .photo]
        guard let resource = preferred.compactMap({ type in resources.first { $0.type == type } }).first else {
            error = "无法准备分享文件，请稍后重试。"
            return
        }
        let token = UUID()
        generation = token
        let folder = FileManager.default.temporaryDirectory.appendingPathComponent("RollKeep-share-" + token.uuidString)
        let name = (resource.originalFilename as NSString).lastPathComponent
        let url = folder.appendingPathComponent(name.isEmpty ? "Media" : name)
        do { try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true) }
        catch { self.error = "无法准备分享文件，请稍后重试。"; return }
        directory = folder
        isLoading = true
        progress = 0
        let options = PHAssetResourceRequestOptions()
        options.isNetworkAccessAllowed = true
        options.progressHandler = { [weak self] value in
            Task { @MainActor in
                guard let self, self.generation == token else { return }
                self.progress = value
            }
        }
        PHAssetResourceManager.default().writeData(for: resource, toFile: url, options: options) { [weak self] error in
            Task { @MainActor in
                guard let self, self.generation == token else {
                    try? FileManager.default.removeItem(at: folder)
                    return
                }
                self.isLoading = false
                if error == nil {
                    self.item = SharedAssetFile(url: url)
                } else {
                    self.cleanup()
                    self.error = "无法准备分享文件，请稍后重试。"
                }
            }
        }
    }

    /// 取消界面等待并清理临时文件；过期的 Photos 回调也会清理输出。
    func cleanup() {
        generation = UUID()
        isLoading = false
        item = nil
        if let directory { try? FileManager.default.removeItem(at: directory) }
        directory = nil
    }
}
