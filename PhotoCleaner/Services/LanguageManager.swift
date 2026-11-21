//
//  LanguageManager.swift
//  应用内多语言与系统语言解析
//

import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case system, zh, en, ja, ko, fr, de, it, es, pt, nl, pl, ru, uk, ar

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: return "跟随系统"
        case .zh:     return "中文"
        case .en:     return "English"
        case .ja:     return "日本語"
        case .ko:     return "한국어"
        case .fr:     return "Français"
        case .de:     return "Deutsch"
        case .it:     return "Italiano"
        case .es:     return "Español"
        case .pt:     return "Português"
        case .nl:     return "Nederlands"
        case .pl:     return "Polski"
        case .ru:     return "Русский"
        case .uk:     return "Українська"
        case .ar:     return "العربية"
        }
    }

    var flag: String {
        switch self {
        case .system: return "globe"
        case .zh:     return "character.bubble"
        case .en:     return "a.circle"
        case .ja:     return "j.circle"
        case .ko:     return "k.circle"
        case .fr, .de, .it, .es, .pt, .nl, .pl, .ru, .uk, .ar: return "character.bubble"
        }
    }

    /// 用于 DateFormatter / NumberFormatter 等系统格式化
    var localeIdentifier: String {
        switch self {
        case .system: return Locale.current.identifier
        case .zh:     return "zh-Hans"
        case .en:     return "en"
        case .ja:     return "ja"
        case .ko:     return "ko"
        case .fr:     return "fr"
        case .de:     return "de"
        case .it:     return "it"
        case .es:     return "es"
        case .pt:     return "pt"
        case .nl:     return "nl"
        case .pl:     return "pl"
        case .ru:     return "ru"
        case .uk:     return "uk"
        case .ar:     return "ar"
        }
    }

    var isRightToLeft: Bool { self == .ar }
}

@MainActor
final class LanguageManager: ObservableObject {
    @AppStorage("app_lang") private var raw: String = AppLanguage.system.rawValue

    var current: AppLanguage {
        AppLanguage(rawValue: raw) ?? .system
    }

    /// 实际使用的语言（解析 system 到具体语言）
    var effective: AppLanguage {
        if current != .system { return current }
        return Self.systemPreferredLanguage()
    }

    /// 解析系统首选语言，避免 Locale.current 被应用默认语言影响
    private static func systemPreferredLanguage() -> AppLanguage {
        let identifiers = Locale.preferredLanguages + [
            Locale.autoupdatingCurrent.identifier,
            Locale.current.identifier
        ]
        for identifier in identifiers {
            if let language = language(from: identifier) {
                return language
            }
        }
        return .zh
    }

    /// 将系统语言标识转换为应用支持的语言
    private static func language(from identifier: String) -> AppLanguage? {
        let normalized = identifier
            .replacingOccurrences(of: "_", with: "-")
            .lowercased()
        if normalized.hasPrefix("zh") { return .zh }
        if normalized.hasPrefix("ja") { return .ja }
        if normalized.hasPrefix("ko") { return .ko }
        if normalized.hasPrefix("en") { return .en }
        if normalized.hasPrefix("fr") { return .fr }
        if normalized.hasPrefix("de") { return .de }
        if normalized.hasPrefix("it") { return .it }
        if normalized.hasPrefix("es") { return .es }
        if normalized.hasPrefix("pt") { return .pt }
        if normalized.hasPrefix("nl") { return .nl }
        if normalized.hasPrefix("pl") { return .pl }
        if normalized.hasPrefix("ru") { return .ru }
        if normalized.hasPrefix("uk") { return .uk }
        if normalized.hasPrefix("ar") { return .ar }
        return nil
    }

    /// 保存应用语言并通知界面刷新。
    func set(_ language: AppLanguage) {
        raw = language.rawValue
        objectWillChange.send()
    }

    /// 中文直接使用原文，其他语言缺失翻译时回退英语。
    func t(_ key: String) -> String {
        let language = effective
        if language == .zh { return key }
        return L10nRegional.dict[language]?[key]
            ?? L10n.dict[key]?[language]
            ?? L10n.dict[key]?[.en]
            ?? key
    }
}
