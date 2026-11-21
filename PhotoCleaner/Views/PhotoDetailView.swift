//
//  PhotoDetailView.swift
//  全屏大图浏览：左右翻页 + 双击/捏合缩放 + 顶部信息按钮 + 跳 Photos.app
//

import SwiftUI
import Photos

struct PhotoDetailView: View {
    @State private var assets: [PHAsset]
    let startAsset: PHAsset

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var library: PhotoLibraryService

    @State private var currentIndex: Int = 0
    @State private var showMetadata = false
    @StateObject private var shareStore = AssetShareStore()
    @EnvironmentObject private var lm: LanguageManager
    @State private var showChrome = true   // 顶部/底部 UI 是否显示
    @State private var isUpdatingFavorite = false
    @State private var isFavorite = false  // 当前照片是否收藏（独立 state，避免 PHAsset 不刷新）
    @State private var assetsRefreshTick = 0 // 用于强制刷新 PHAsset 状态

    /// 直接定位到用户选择的照片，避免先加载队列首张大图。
    init(assets: [PHAsset], startAsset: PHAsset) {
        _assets = State(initialValue: assets)
        self.startAsset = startAsset
        _currentIndex = State(initialValue: assets.firstIndex { $0.localIdentifier == startAsset.localIdentifier } ?? 0)
    }

    private var currentAsset: PHAsset? {
        guard currentIndex >= 0, currentIndex < assets.count else { return nil }
        // 重新 fetch 拿最新 PHAsset（修改 isFavorite 等需要新实例）
        _ = assetsRefreshTick
        let id = assets[currentIndex].localIdentifier
        let fetched = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        return fetched.firstObject ?? assets[currentIndex]
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // 翻页：用 TabView 的 page 样式
            TabView(selection: $currentIndex) {
                ForEach(assets.indices, id: \.self) { idx in
                    Group {
                        if idx == currentIndex, assets[idx].mediaType == .video {
                            AssetVideoPlayer(asset: assets[idx])
                        } else if abs(idx - currentIndex) <= 1 {
                            ZoomablePhoto(asset: assets[idx])
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) { showChrome.toggle() }
                                }
                        } else {
                            Color.black
                        }
                    }
                        .id("\(assets[idx].localIdentifier)-\(assets[idx].modificationDate?.timeIntervalSince1970 ?? 0)")
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            // 顶部工具栏
            if showChrome {
                VStack(spacing: 0) {
                    topBar
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    Spacer()
                    bottomBar
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                }
                .transition(.opacity)
            }
        }
        .statusBarHidden(!showChrome)
        .onAppear {
            refreshFavoriteState()
        }
        .onChange(of: currentIndex) { _, _ in
            shareStore.cleanup()
            refreshFavoriteState()
        }
        .task(id: library.revision) {
            let id = currentAsset?.localIdentifier
            let updated = await library.refreshedAssets(assets.map(\.localIdentifier))
            guard !Task.isCancelled else { return }
            guard !updated.isEmpty else { dismiss(); return }
            assets = updated
            currentIndex = id.flatMap { value in updated.firstIndex { $0.localIdentifier == value } } ?? min(currentIndex, updated.count - 1)
            refreshFavoriteState()
        }
        .sheet(item: $shareStore.item, onDismiss: { shareStore.cleanup() }) { item in
            PhotoShareSheet(items: [item.url])
        }
        .overlay {
            if shareStore.isLoading {
                VStack(spacing: 16) {
                    ProgressView(lm.t("正在准备分享…"))
                    if shareStore.progress > 0 { ProgressView(value: shareStore.progress) }
                    Button(lm.t("取消")) { shareStore.cleanup() }
                }
                .padding(24).frame(maxWidth: 300)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            }
        }
        .alert(lm.t("分享未完成"), isPresented: Binding(get: { shareStore.error != nil }, set: { if !$0 { shareStore.error = nil } })) {
            Button(lm.t("确认"), role: .cancel) { shareStore.error = nil }
        } message: { Text(lm.t(shareStore.error ?? "")) }
        .onDisappear { shareStore.cleanup() }
        .sheet(isPresented: $showMetadata) {
            if let asset = currentAsset {
                PhotoMetadataSheet(asset: asset)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    // MARK: - 顶部栏

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(.black.opacity(0.5)))
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.cancelAction)
            .accessibilityLabel(lm.t("关闭"))

            Spacer()

            if let asset = currentAsset {
                VStack(spacing: 2) {
                    Text("\(currentIndex + 1) / \(assets.count)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.85))
                    Text(formattedDate(asset.creationDate))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().fill(.black.opacity(0.45)))
            }

            Spacer()

            Button {
                showMetadata = true
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(.black.opacity(0.5)))
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - 底部栏

    private var bottomBar: some View {
        HStack(spacing: 18) {
            // 收藏 / 取消收藏（用 isFavorite state 而非 PHAsset.isFavorite，保证即时刷新）
            iconButton(symbol: isFavorite ? "heart.fill" : "heart", label: lm.t(isFavorite ? "取消收藏" : "收藏"),
                        tint: isFavorite ? .red : .white) {
                toggleFavorite()
            }
            .disabled(isUpdatingFavorite)

            Spacer()

            // 分享
            iconButton(symbol: "square.and.arrow.up", label: lm.t("分享"), tint: .white) {
                share()
            }

            // 在 Photos.app 中打开
            iconButton(symbol: "arrow.up.right.square", label: lm.t("在 照片 App 中打开"), tint: .white) {
                openInPhotosApp()
            }

            // 详情
            iconButton(symbol: "info.circle.fill", label: lm.t("照片信息"), tint: AppPalette.brand) {
                showMetadata = true
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            Capsule().fill(.black.opacity(0.6))
                .overlay(Capsule().strokeBorder(.white.opacity(0.08), lineWidth: 1))
        )
    }

    /// 提供足够的触控面积与 VoiceOver 操作名称。
    private func iconButton(symbol: String, label: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button {
            AppHaptics.impact(.light)
            action()
        } label: {
            Image(systemName: symbol)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }

    // MARK: - 操作

    /// 收藏完成后只更新同一张照片的工具栏，避免切页期间错改状态。
    private func toggleFavorite() {
        guard !isUpdatingFavorite, let asset = currentAsset else { return }
        isUpdatingFavorite = true
        let id = asset.localIdentifier
        let newValue = !asset.isFavorite
        // 立即更新 UI state，避免等系统回调的延迟
        isFavorite = newValue

        PHPhotoLibrary.shared().performChanges({
            let r = PHAssetChangeRequest(for: asset)
            r.isFavorite = newValue
        }, completionHandler: { success, _ in
            DispatchQueue.main.async {
                isUpdatingFavorite = false
                guard currentAsset?.localIdentifier == id else { return }
                if success {
                    // 强制 fetch 最新 PHAsset
                    assetsRefreshTick += 1
                } else {
                    // 失败回滚
                    isFavorite = !newValue
                }
            }
        })
    }

    /// 切换当前照片时同步 isFavorite state
    private func refreshFavoriteState() {
        isFavorite = currentAsset?.isFavorite ?? false
    }

    /// 打开系统照片应用，交由 Photos 管理媒体。
    private func openInPhotosApp() {
        if let url = URL(string: "photos-redirect://"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let url = URL(string: "photos://") {
            UIApplication.shared.open(url)
        }
    }

    /// 导出实际照片或视频文件后呈现系统分享面板。
    private func share() {
        guard let asset = currentAsset else { return }
        shareStore.prepare(asset)
    }

    /// 按当前语言格式化照片日期。
    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "" }
        let f = DateFormatter()
        f.setLocalizedDateFormatFromTemplate("yMMMdHm")
        return f.string(from: date)
    }
}

// MARK: - 单张可缩放照片

private struct ZoomablePhoto: View {
    let asset: PHAsset
    @EnvironmentObject private var library: PhotoLibraryService

    @State private var image: UIImage?
    @State private var failed = false
    @State private var progress = 0.0
    @State private var generation = UUID()
    @EnvironmentObject private var lm: LanguageManager
    @Environment(\.displayScale) private var displayScale
    @State private var livePhoto: PHLivePhoto?
    @State private var reqID: PHImageRequestID?
    @State private var liveReqID: PHImageRequestID?
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    private var isLivePhoto: Bool {
        asset.mediaSubtypes.contains(.photoLive)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                // Live Photo 用 PHLivePhotoView（自动触摸长按播放），无 zoom
                if isLivePhoto, let livePhoto {
                    LivePhotoView(livePhoto: livePhoto)
                        .frame(width: geo.size.width, height: geo.size.height)
                } else if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            // 捏合缩放
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = max(1, min(4, lastScale * value))
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                    if scale < 1.05 {
                                        withAnimation(.spring()) {
                                            scale = 1; lastScale = 1
                                            offset = .zero; lastOffset = .zero
                                        }
                                    }
                                }
                        )
                        .simultaneousGesture(
                            // 平移
                            DragGesture()
                                .onChanged { value in
                                    if scale > 1 {
                                        offset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                    }
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                        .onTapGesture(count: 2) {
                            // 双击切换 1x / 2x
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                if scale > 1 {
                                    scale = 1; lastScale = 1
                                    offset = .zero; lastOffset = .zero
                                } else {
                                    scale = 2; lastScale = 2
                                }
                            }
                        }
                } else {
                    VStack(spacing: 16) {
                        if failed {
                            Text(lm.t("无法加载媒体，请检查网络后重试。"))
                            Button(lm.t("重新加载")) { load() }.buttonStyle(.bordered)
                        } else {
                            ProgressView().tint(.white)
                            if progress > 0 { ProgressView(value: progress).frame(maxWidth: 240) }
                        }
                    }.foregroundStyle(.white).padding()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onChange(of: geo.size) { _, _ in
                scale = 1
                lastScale = 1
                offset = .zero
                lastOffset = .zero
            }
        }
        .onAppear { load() }
        .onDisappear {
            generation = UUID()
            if let id = reqID { library.cancelImageRequest(id) }
            if let id = liveReqID { library.cancelImageRequest(id) }
        }
    }

    /// 加载有限尺寸的预览和实况资源，失败时提供重新加载入口。
    private func load() {
        if let reqID { library.cancelImageRequest(reqID) }
        if let liveReqID { library.cancelImageRequest(liveReqID) }
        let token = UUID()
        generation = token
        failed = false
        progress = 0
        let size = CGSize(width: 2400, height: 2400)
        reqID = library.loadImage(for: asset, targetSize: size, deliveryMode: .highQualityFormat, progress: { value in
            guard generation == token else { return }
            progress = value
        }, failure: {
            guard generation == token else { return }
            failed = true
        }) { image in
            guard generation == token else { return }
            self.image = image
        }
        if isLivePhoto {
            liveReqID = library.loadLivePhoto(for: asset, targetSize: size) { live in
                guard generation == token else { return }
                livePhoto = live
            }
        }
    }
}

/// 由 SwiftUI 管理分享面板的呈现位置与生命周期。
struct PhotoShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    /// 兼容仅分享当前预览图片的调用方。
    init(image: UIImage) { self.items = [image] }

    /// 分享已准备好的本地文件或其他系统可识别项目。
    init(items: [Any]) { self.items = items }

    /// 创建系统分享控制器；交由所在 sheet 适配当前设备。
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    /// 图片在呈现前确定，无需额外更新控制器。
    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}
