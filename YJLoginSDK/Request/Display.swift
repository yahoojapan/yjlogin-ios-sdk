//
//  Display.swift
//  YJLoginSDK
//
//  © 2023 LY Corporation. All rights reserved.
//

import Foundation

/// ログイン画面と同意画面で表示するページ種類として、認可リクエストに設定する値。
/// 初期値は`page`。
public enum Display: String {
    /// ネイティブアプリ版ページ。
    case inapp

    /// UserAgentに適したページ。
    /// 初期値。
    case page

    /// ポップアップ版ページ。
    case popup

    /// スマートフォン版ページ。
    case touch
}
