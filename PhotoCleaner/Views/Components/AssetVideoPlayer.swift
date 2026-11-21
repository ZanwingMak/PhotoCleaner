import SwiftUI
import Photos
import AVKit

/// 仅加载当前可见的视频，保留系统播放控制与 iCloud 加载反馈。
struct AssetVideoPlayer: View {
    let asset: PHAsset
    @EnvironmentObject private var lm: LanguageManager
    @State private var player: AVPlayer?
    @State private var requestID: PHImageRequestID?
    @State private var generation = UUID()
    @State private var progress = 0.0
    @State private var failed = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            Color.black
            if let player {
                VideoPlayer(player: player)
            } else {
                VStack(spacing: 16) {
                    if failed {
                        Image(systemName: "icloud.slash").font(.largeTitle)
                        Text(lm.t("无法加载媒体，请检查网络后重试。"))
                        Button(lm.t("重新加载")) { load() }.buttonStyle(.bordered)
                    } else {
                        ProgressView().tint(.white)
                        if progress > 0 { ProgressView(value: progress).frame(maxWidth: 240) }
                        Text(lm.t("正在准备视频…"))
                    }
                }
                .foregroundStyle(.white)
                .padding()
            }
        }
        .onAppear { load() }
        .onDisappear { stop() }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active { player?.pause() }
        }
    }

    /// 请求可播放的视频项；播放由用户操作系统控件触发。
    private func load() {
        stop()
        failed = false
        progress = 0
        let token = UUID()
        generation = token
        let options = PHVideoRequestOptions()
        options.deliveryMode = .automatic
        options.isNetworkAccessAllowed = true
        options.progressHandler = { value, _, _, _ in
            Task { @MainActor in
                guard generation == token else { return }
                progress = value
            }
        }
        requestID = PHImageManager.default().requestPlayerItem(forVideo: asset, options: options) { item, _ in
            Task { @MainActor in
                guard generation == token else { return }
                if let item { player = AVPlayer(playerItem: item) }
                else { failed = true }
            }
        }
    }

    /// 停止离屏视频和未完成的下载请求，防止后台继续播放。
    private func stop() {
        generation = UUID()
        player?.pause()
        player = nil
        if let requestID { PHImageManager.default().cancelImageRequest(requestID) }
        requestID = nil
    }
}
