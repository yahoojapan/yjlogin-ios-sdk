//
//  LoginButton.swift
//  YJLoginSDK
//
//  Copyright © 2019 Yahoo Japan Corporation. All rights reserved.
//

import UIKit

/// `LoginButton`クラスを使用する際に、ログインアクションの状態を制御するためのDelegate。
public protocol LoginButtonDelegate: AnyObject {

    /// ログインボタンが押された直後に呼ばれる。
    /// - Parameter button: ログインアクションの開始時に押下されたボタン。
    func loginButtonDidStartLogin(_ button: LoginButton)

    /// ログインアクションが成功したときに呼ばれる。
    /// - Parameter button: ログインアクションの開始時に押下されたボタン。
    /// - Parameter loginResult: 成功したログインアクションのログイン結果。
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult)

    /// ログインアクションが失敗したときに呼ばれる。
    /// - Parameter button: ログインアクションの開始時に押下されたボタン。
    /// - Parameter error: 失敗したログインアクションのエラー。
    func loginButton(_ button: LoginButton, didFailLogin error: LoginError)
}

/// ログインボタン。
/// [Yahoo! JAPAN IDログインボタン デザインガイドライン](https://developer.yahoo.co.jp/yconnect/loginbuttons.html)に準拠。
public class LoginButton: UIButton {

    // MARK: Enum
    /// ログインボタンのデザインスタイル。
    public enum Style {
        /// アイコンのみ。
        /// サイズは44 x 44。
        case icon
        /// アイコンとテキスト。
        /// サイズは192 x 40。
        case normal
        /// アイコンサイズ。
        var size: CGSize {
            switch self {
            case .icon:
                return CGSize(width: 44.0, height: 44.0)
            case .normal:
                return CGSize(width: 192.0, height: 40.0)
            }
        }
    }

    /// ログインボタンの色。
    public enum Color {
        /// 赤。
        case red
        /// 白。
        case white
    }

    // MARK: Public propety
    /// `LoginButtonDelegate`プロトコルを実装したログインアクションを制御するためのプロパティ。
    public weak var delegate: LoginButtonDelegate?

    /// ログイン画面を表示するViewController。nilの場合は最前面のViewControllerにログイン画面を表示する。
    weak public var presentingViewController: UIViewController?

    /// 認可リクエストで指定する`Scope`。
    public var scopes: [Scope] = [.openid, .profile]

    /// 認可リクエストで指定するnonce。
    public var nonce: String!

    /// 認可リクエストで指定するcodeChallenge。
    public var codeChallenge: String!

    /// 認可リクエストで指定するその他の任意パラメーター。
    public var optionalParameters: OptionalParameters?

    internal var process: AuthenticationProcessProtocol?

    /// ログインボタンのデザインスタイル。
    public var style: Style = .normal {
        didSet {
            updateAppearence()
        }
    }

    /// ログインボタンのアイコン背景色。
    public var iconBackgroundColor: Color = .white {
        didSet {
            updateAppearence()
        }
    }

    /// Auto Layout対応のためオーバーライド。
    override public var intrinsicContentSize: CGSize {
        return style.size
    }

    // MARK: Public function
    /// ログインボタンを生成。
    public init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: Private function
    @objc private func login() {
        isUserInteractionEnabled = false
        delegate?.loginButtonDidStartLogin(self)
        let process = self.process ?? AuthenticationProcess(viewController: presentingViewController)
        LoginManager.shared.login(scopes: scopes, nonce: nonce, codeChallenge: codeChallenge, process: process, optionalParameters: optionalParameters) {[weak self] result in
            if let self = self {
                switch result {
                case .success(let response):
                    self.delegate?.loginButton(self, didSucceedLogin: response)
                case .failure(let error):
                    self.delegate?.loginButton(self, didFailLogin: error)
                }
                self.isUserInteractionEnabled = true
            }
        }
    }

    private func setup() {
        addTarget(self, action: #selector(login), for: .touchUpInside)
        updateAppearence()
    }

    private func updateAppearence() {
        let imageName: String!
        let bundle = Bundle(for: LoginButton.self)

        switch iconBackgroundColor {
        case .red:
            switch style {
            case .icon:
                imageName = "icon_red"
            case .normal:
                imageName = "button_red"
            }
        case .white:
            switch style {
            case .icon:
                imageName = "icon_white"
            case .normal:
                imageName = "button_white"
            }
        }

        setImage(UIImage(named: imageName, in: bundle, compatibleWith: nil), for: .normal)
    }
}
