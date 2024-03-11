//
//  Constants.swift
//  YJLoginSDK
//
//  © 2023 LY Corporation. All rights reserved.
//

import Foundation
internal struct Constant {
    // swiftlint:disable:next force_unwrapping
    static let issuer = URL(string: "https://auth.login.yahoo.co.jp/yconnect/v2")!
    static let authorizationPath = "/authorization"
    static let appAuthPath = "/appauth"
}
