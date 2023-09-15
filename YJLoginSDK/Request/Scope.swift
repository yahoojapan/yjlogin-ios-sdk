//
//  Scope.swift
//  YJLoginSDK
//
//  © 2019 LY Corporation. All rights reserved.
//

import Foundation

/// UserInfo APIから取得する属性情報として、認可リクエストに設定する値。
/// 詳細は[こちら](https://developer.yahoo.co.jp/yconnect/v2/userinfo.html)。
public enum Scope: String {
    /// 住所。
    case address

    /// メールアドレス。
    case email

    /// ユーザー識別子。
    case openid

    /// 名前、性別などのその他属性情報。
    case profile
}
