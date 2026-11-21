//
//  LivePhotoView.swift
//  PHLivePhotoView 的 SwiftUI 包装
//

import SwiftUI
import Photos
import PhotosUI

/// 显示 PHLivePhoto 的 SwiftUI 视图
struct LivePhotoView: UIViewRepresentable {
    let livePhoto: PHLivePhoto?
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var autoPlay: Bool = true   // 加载完成后自动播放一次

    /// 创建实况照片容器，保留系统长按播放手势。
    func makeUIView(context: Context) -> PHLivePhotoView {
        let view = PHLivePhotoView()
        view.contentMode = contentMode
        return view
    }

    /// 仅在媒体变化时播放一次提示，避免普通界面刷新重复触发。
    func updateUIView(_ uiView: PHLivePhotoView, context: Context) {
        guard uiView.livePhoto !== livePhoto else { return }
        uiView.stopPlayback()
        uiView.livePhoto = livePhoto
        if autoPlay, livePhoto != nil { uiView.startPlayback(with: .hint) }
    }

    /// 移除视图时停止播放并释放实况资源。
    static func dismantleUIView(_ uiView: PHLivePhotoView, coordinator: ()) {
        uiView.stopPlayback()
        uiView.livePhoto = nil
    }
}
