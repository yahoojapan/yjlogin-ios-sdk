//
//  OptionalParameters.swift
//  YJLoginSDK
//
//  Copyright © LY Corporation. All rights reserved.
//

import Foundation

/// 認可リクエスト時に指定する任意パラメーター。
public struct OptionalParameters {

    /// 同意画面で「同意しない」ボタンをクリックした際の遷移先。
    /// true: redirect_uriにcodeパラメーターを付加せず遷移。
    /// false or nil: Yahoo! JAPAN TOPページへ遷移。
    public var bail: Bool?

    /// ログイン画面と同意画面で表示するページ種類。
    public var display: Display?

    /// 最大認証経過時間。
    /// 指定された秒数よりも認証日時が経過していた場合は再認証を要求。
    public var maxAge: Int?

    /// ユーザーに強制させたいアクション。
    public var prompts: [Prompt]?

    /// その他未定義のパラメーター。
    ///
    /// - Note:
    ///   定義されていないパラメーターを指定したい場合に使用。
    public var additionalParameters: [String: String]?

    /// 指定されたパラメーターを元にインスタンスを生成。
    /// - Parameter bail: 同意画面で「同意しない」ボタンをクリックした際の遷移先。
    /// - Parameter display: ログイン画面と同意画面で表示するページ種類。
    /// - Parameter maxAge: 最大認証経過時間。
    /// - Parameter prompts: ユーザーに強制させたいアクション。
    /// - Parameter additionalParameters: その他未定義のパラメーター。
    public init(
        bail: Bool? = nil,
        display: Display? = nil,
        maxAge: Int? = nil,
        prompts: [Prompt]? = nil,
        additionalParameters: [String: String]? = nil
    ) {
        self.bail = bail
        self.display = display
        self.maxAge = maxAge
        self.prompts = prompts
        self.additionalParameters = additionalParameters
    }

    internal func allParameters() -> [String: String]? {
        var parameters = [String: String]()
        if bail != nil { parameters["bail"] = "1" }

        if let display = display { parameters["display"] = display.rawValue }

        if let maxAge = maxAge { parameters["max_age"] = String(maxAge) }

        if let prompts = prompts { parameters["prompt"] = prompts.map {$0.rawValue}.joined(separator: " ") }

        if let additionalParameters = additionalParameters {
            parameters.merge(additionalParameters) {(_, additionalParametersValue) in additionalParametersValue}
        }
        return parameters
    }
}
