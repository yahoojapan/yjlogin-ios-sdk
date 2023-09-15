//
//  LoginError.swift
//  YJLoginSDK
//
//  © 2019 LY Corporation. All rights reserved.
//

import Foundation

/// YJLoginSDKがログイン処理の結果として返却するエラー。
public enum LoginError: Error {

    /// 認可リクエストに問題がある場合。
    case requestFailed(RequestErrorReason)

    /// 認可レスポンスが不正な場合。
    case responseFailed(ResponseFailedReason)

    /// ユーザーが同意をキャンセルした場合。
    case userCancel

    /// Yahoo! ID連携のシステムエラーが発生している場合。
    case systemError(SystemErrorReason)

    /// ユーザーによるインタラクションが必要な場合。
    case userInteractionRequired(UserInteractionRequiredReason)

    /// 想定外のエラーが発生した場合。
    case undefinedError(error: Error?)

    /// 同時に認証処理が実行されている場合。
    case authenticating

    // MARK: Enum
    /// `LoginError.requestFailed(_:)`のエラー発生原因。
    public enum RequestErrorReason {

        /// ユーザーか認可サーバーがリクエストを拒否した場合。
        case accessDenied(DetailResponse)

        /// 要求したスコープが不正、未知、もしくはその他の不当な形式の場合。
        case invalidScope(DetailResponse)

        /// 下記のいずれかを満たす場合。
        /// - リクエストに必要なパラメーターが含まれていない場合。
        /// - サポートされていないパラメーターが含まれている場合。
        /// - 同一のパラメーターが複数含まれる場合。
        /// - その他不正な形式であった場合。
        case invalidRequest(DetailResponse)

        /// 認可サーバーが現在の方法による認可コード取得をサポートしていない場合。
        case unsupportedResponseType(DetailResponse)
    }

    /// `LoginError.responseFailed(_:)`のエラー発生原因。
    public enum ResponseFailedReason {

        /// stateパラメーターの検証に失敗した場合。
        case invalidState

        /// 未定義のエラー。
        case undefined(DetailResponse)
    }

    /// `LoginError.systemError(_:)`のエラー発生原因。
    public enum SystemErrorReason {
        /// システムエラーが発生している場合。
        case systemError(DetailResponse)
    }

    /// `LoginError.userInteractionRequired(_:)`のエラー発生原因。
    public enum UserInteractionRequiredReason {

        /// `prompt`パラメーターが`nonce`を指定しており、ユーザーの同意のために画面を表示しなければならない場合。
        case consentRequired(DetailResponse)

        /// `prompt`パラメーターが`nonce`を指定しており、ユーザーの認証のために画面を表示しなければならない場合。
        case loginRequired(DetailResponse)

        /// `prompt`パラメーターが`nonce`を指定しており、上記以外の原因のために画面を表示しなければならない場合。
        case interactionRequired(DetailResponse)
    }

    /// 認可レスポンスのエラー詳細。
    public struct DetailResponse {
        /// エラー種別ごとに定義される文字列。
        let error: String

        /// 開発者が読むためのエラー説明文。
        let errorDescription: String

        /// エラーごとにユニークなエラーコード値。
        let errorCode: Int
    }
}
