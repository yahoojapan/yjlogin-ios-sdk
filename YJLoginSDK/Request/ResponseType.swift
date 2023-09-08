//
//  ResponseType.swift
//  YJLoginSDK
//
//  Copyright © LY Corporation. All rights reserved.
//

import Foundation

/// Yahoo! ID連携の認可レスポンスとして取得するパラメーターを指定するために、認可リクエストに設定する値。
public enum ResponseType: String {
    /// Authorization Codeのみを取得。
    case code
}
