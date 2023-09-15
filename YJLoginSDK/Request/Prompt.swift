//
//  Prompt.swift
//  YJLoginSDK
//
//  Copyright © 2019 Yahoo Japan Corporation. All rights reserved.
//

import Foundation

/// ユーザーに強制させたいアクションとして、認可リクエストに設定する値。
public enum Prompt: String {
    /// 同意を要求。
    case consent

    /// 再認証を要求。
    case login

    /// 画面を非表示。
    case none

    /// ID切り替えを強制。
    case selectAccount = "select_account"
}
