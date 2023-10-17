//
//  LoginConfiguration.swift
//  YJLoginSDK
//
//  © 2023 LY Corporation. All rights reserved.
//

import Foundation

internal struct LoginConfiguration {
    let clientId: String
    let redirectUri: URL
    var issuer: URL
    var enableUniversalLinks: Bool
}
