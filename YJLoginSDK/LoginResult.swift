//
//  LoginResult.swift
//  YJLoginSDK
//
//  Copyright © 2019 Yahoo Japan Corporation. All rights reserved.
//

/// 認可リクエストが成功した結果。
public struct LoginResult {
    // MARK: Public property
    /// 認可コード。
    public let authorizationCode: String

    internal let state: String?
}
