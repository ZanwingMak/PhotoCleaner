//
//  RootView.swift
//  入口分发：根据授权状态展示引导页或主界面
//

import SwiftUI
import Photos
import PhotosUI

struct RootView: View {
    @EnvironmentObject private var library: PhotoLibraryService
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var usage: UsageTracker

    var body: some View {
        Group {
            switch library.authorizationStatus {
            case .authorized, .limited:
                CategoryListView()
            case .denied, .restricted:
                PermissionDeniedView()
            case .notDetermined:
                PermissionView()
            @unknown default:
                PermissionView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: library.authorizationStatus)
        .task {
            // 先展示用途说明；只有用户点击按钮后才触发系统权限弹窗
            library.refreshAuthorizationStatus()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                usage.refreshDay()
                library.refreshAuthorizationStatus()
            }
        }
    }
}

/// 首次启动：解释为什么需要权限，再请求
struct PermissionView: View {
    @EnvironmentObject private var library: PhotoLibraryService
    @EnvironmentObject private var lm: LanguageManager

    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                colors: [Color(.systemBackground), Color.blue.opacity(0.08), Color.purple.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 32) {
                        Spacer()

                        // 图标
                        Image(systemName: "photo.stack.fill")
                            .font(.system(size: 72, weight: .light))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )

                        VStack(spacing: 12) {
                            Text(lm.t("整理你的照片库"))
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                            Text(lm.t("快速滑动审核每张照片，腾出存储空间。\n所有删除操作都需要你手动确认。"))
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }

                        Spacer()

                        Button {
                            Task { await library.requestAuthorization() }
                        } label: {
                            Text(lm.t("允许访问照片"))
                                .font(.system(size: 17, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background {
                                    if #available(iOS 26.0, *) {
                                        Capsule().fill(.clear).glassEffect(.regular.tint(.blue.opacity(0.35)).interactive(), in: .capsule)
                                    } else {
                                        Capsule().fill(Color.blue)
                                    }
                                }
                                .foregroundStyle(.white)
                        }
                        .keyboardShortcut(.defaultAction)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 32)
                    }
                    .frame(maxWidth: 600, minHeight: geometry.size.height)
                    .frame(maxWidth: .infinity)
                }
            }

        }
    }
}

/// 用户拒绝授权时的引导
struct PermissionDeniedView: View {
    @EnvironmentObject private var lm: LanguageManager

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.fill")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            Text(lm.t("无法访问照片"))
                .font(.title2.weight(.semibold))
            Text(lm.t("请在「设置 → 隐私与安全性 → 照片」中允许 RollKeep 访问。"))
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text(lm.t("打开设置"))
                    .padding(.horizontal, 24).padding(.vertical, 12)
                    .background(Capsule().fill(.tint.opacity(0.15)))
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

/// 部分权限下说明可见范围，允许用户主动调整系统授权的照片。
struct LimitedPhotoAccessNotice: View {
    @EnvironmentObject private var lm: LanguageManager
    @State private var showPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(lm.t("当前仅可访问部分照片"))
                .font(.subheadline.weight(.semibold))
            Text(lm.t("仅显示你允许访问的照片和视频，可随时调整选择。"))
                .font(.caption)
                .foregroundStyle(.secondary)
            Button {
                showPicker = true
            } label: {
                Label(lm.t("管理可访问的照片"), systemImage: "photo.badge.plus")
                    .font(.subheadline)
                    .frame(minHeight: 32)
            }
            .buttonStyle(.bordered)
            .disabled(showPicker)
            .background {
                LimitedPhotoLibraryPicker(isPresented: $showPicker)
                    .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AppPalette.brand.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
    }
}

/// 从当前窗口内的控制器弹出系统授权选择器，避免查找全局窗口。
private struct LimitedPhotoLibraryPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    /// 创建随按钮附着于当前窗口的透明展示锚点。
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }

    /// 仅响应主动点击，系统完成选择后恢复按钮状态。
    func updateUIViewController(_ controller: UIViewController, context: Context) {
        guard isPresented, !context.coordinator.isPresenting,
              controller.viewIfLoaded?.window != nil else { return }
        let binding = $isPresented
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) == .limited else {
            Task { @MainActor in binding.wrappedValue = false }
            return
        }
        let coordinator = context.coordinator
        coordinator.isPresenting = true
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: controller) { _ in
            Task { @MainActor in
                coordinator.isPresenting = false
                binding.wrappedValue = false
            }
        }
    }

    /// 维持系统弹窗状态，避免 SwiftUI 更新时重复呈现。
    func makeCoordinator() -> Coordinator { Coordinator() }

    @MainActor
    final class Coordinator {
        var isPresenting = false
    }
}
