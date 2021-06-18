//
//  LoginManager.swift
//  YJLoginSDK
//
//  Copyright © 2019 Yahoo Japan Corporation. All rights reserved.
//

import AuthenticationServices
import Foundation
import SafariServices

/// ログインマネージャー。
/// Yahoo! ID連携のクライアントに関する設定をし、認可リクエストを実行した結果を返す。
public class LoginManager {

    // MARK: Public propety
    /// ログインマネージャーの共有インスタンス。
    public static let shared = LoginManager()

    // MARK: Private propety
    private var configuration: LoginConfiguration?

    private var authenticationProcess: AuthenticationProcessProtocol?

    // MARK: Public function
    /// `LoginManager`の設定を行う。
    ///
    /// - Parameter clientId: アプリケーション登録時に発行したClient ID。
    /// - Parameter redirectUri: アプリケーション登録時に設定したフルURLもしくはカスタムURIスキーム。
    public func setup(clientId: String, redirectUri: URL) {
        configuration = LoginConfiguration(clientId: clientId, redirectUri: redirectUri, issuer: Constant.issuer)
    }

    /// Issuerの設定を行う。
    ///
    /// - Parameter issuer: Issuer。
    public func setIssuer(issuer: URL) {
        guard let host = issuer.host, host.hasSuffix(".yahoo.co.jp") else {
            fatalError("[YJLoginSDK] Please set valid issuer.")
        }

        guard issuer.path == "/yconnect/v2" else {
            fatalError("[YJLoginSDK] Please set valid issuer.")
        }

        configuration?.issuer = issuer
    }

    /// Yahoo! ID連携でログインを行う。
    ///
    /// - Parameter scopes: 要求する`Scope`の配列。`.openid`は必須。
    /// - Parameter nonce: リプレイアタック対策のパラメーター。
    /// - Parameter codeChallenge: PKCEのパラメーター。
    /// - Parameter optionalParameters: 認可リクエスト時に指定する任意パラメーター。
    /// - Parameter viewController: ログイン画面を表示するViewController。nilの場合は最前面のViewControllerにログイン画面を表示する。
    /// - Parameter completion: ログインアクション完了時に実行されるクロージャー。
    ///
    /// - Note:
    ///   ログイン処理は同時に1つしか実行されない。
    ///   メソッド呼び出し時にログイン処理が行われている場合、`LoginError.authenticating`のエラーを返す。
    public func login(
        scopes: [Scope],
        nonce: String,
        codeChallenge: String,
        optionalParameters: OptionalParameters? = nil,
        viewController: UIViewController? = nil,
        completionHandler completion: @escaping (Result<LoginResult, LoginError>) -> Void) {
        login(scopes: scopes, nonce: nonce, codeChallenge: codeChallenge, process: AuthenticationProcess(viewController: viewController), optionalParameters: optionalParameters, completionHandler: completion)
    }

    /// AppDelegateからアプリにログイン処理が返ってきた際に、URLの処理を制御する。
    ///
    /// - Parameter app: アプリのシングルトン。
    /// - Parameter url: アプリが起動された際のURL。
    /// - Parameter options: URL制御のオプション。
    ///
    /// - Note:
    ///   iOS10をサポートする場合は必須。
    public func application(_ app: UIApplication, open url: URL?, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        guard let url = url else { return false }

        guard let authenticationProcess = self.authenticationProcess else {
            return false
        }
        return authenticationProcess.resume(url: url)
    }

    // MARK: Internal function
    internal func login(
        scopes: [Scope],
        nonce: String,
        codeChallenge: String,
        process: AuthenticationProcessProtocol,
        optionalParameters: OptionalParameters? = nil,
        completionHandler completion: @escaping (Result<LoginResult, LoginError>) -> Void) {

        guard let configuration = configuration else {
            fatalError("[YJLoginSDK] Please call setup function before login.")
        }

        guard authenticationProcess == nil else {
            completion(.failure(LoginError.authenticating))
            return
        }

        let state =  try? SecureRandom.data(count: 32).base64urlEncodedString()

        let request = AuthenticationRequest(clientId: configuration.clientId, codeChallenge: codeChallenge, nonce: nonce, redirectUri: configuration.redirectUri, responseType: .code, scopes: scopes, state: state, optionalParameter: optionalParameters, issuer: configuration.issuer)

        authenticationProcess = process
        authenticationProcess?.onFinish = { [weak self] (result) in
            completion(result)
            self?.authenticationProcess = nil
        }
        authenticationProcess?.start(request: request)
    }
}
