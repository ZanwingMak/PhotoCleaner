//
//  AppHaptics.swift
//  统一遵循用户的触觉反馈偏好
//

import UIKit

enum AppHaptics {
    /// 当前是否允许触觉反馈；首次使用默认开启
    private static var isEnabled: Bool {
        guard UserDefaults.standard.object(forKey: "haptics_enabled") != nil else { return true }
        return UserDefaults.standard.bool(forKey: "haptics_enabled")
    }

    /// 在用户允许时触发轻重反馈
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard isEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    /// 在用户允许时触发结果反馈
    static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}
