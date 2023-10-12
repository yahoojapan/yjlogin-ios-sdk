//
//  ViewController.swift
//  YJLoginSDKSample
//
//  © 2023 LY Corporation. All rights reserved.
//

import UIKit
import AuthenticationServices
import YJLoginSDK

class ViewController: UIViewController {

    var button: UIButton!
    var whiteIconButton: LoginButton!
    var redIconButton: LoginButton!

    var whiteButton: LoginButton!
    var redButton: LoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        button = UIButton(frame: CGRect(x: 0, y: 0, width: 190, height: 40))
        button.backgroundColor = .red
        button.setTitle("ログイン", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // nonceとcode_challengeはサーバーで生成し、代入してください。

        whiteButton = LoginButton()
        whiteButton.scopes = [.openid, .profile]
        whiteButton.nonce = "<nonce>"
        whiteButton.codeChallenge = "<code_challenge>"
        whiteButton.presentingViewController = self
        whiteButton.optionalParameters = OptionalParameters(bail: true)
        whiteButton.delegate = self

        redButton = LoginButton()
        redButton.iconBackgroundColor = .red
        redButton.scopes = [.openid, .profile]
        redButton.nonce = "<nonce>"
        redButton.codeChallenge = "<code_challenge>"
        redButton.optionalParameters = OptionalParameters(bail: true)
        redButton.delegate = self

        whiteIconButton = LoginButton()
        whiteIconButton.style = .icon
        whiteIconButton.scopes = [.openid, .profile]
        whiteIconButton.nonce = "<nonce>"
        whiteIconButton.codeChallenge = "<code_challenge>"
        whiteIconButton.optionalParameters = OptionalParameters(bail: true)
        whiteIconButton.delegate = self

        redIconButton = LoginButton()
        redIconButton.iconBackgroundColor = .red
        redIconButton.style = .icon
        redIconButton.scopes = [.openid, .profile]
        redIconButton.nonce = "<nonce>"
        redIconButton.codeChallenge = "<code_challenge>"
        redIconButton.optionalParameters = OptionalParameters(bail: true)
        redIconButton.delegate = self

        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300))
        stackView.center = view.center
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8

        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(whiteButton)
        stackView.addArrangedSubview(redButton)
        stackView.addArrangedSubview(whiteIconButton)
        stackView.addArrangedSubview(redIconButton)

        view.addSubview(stackView)
    }

    @objc func buttonTapped() {
        // nonceとcode_challengeはサーバーで生成し、代入してください。
        LoginManager.shared.login(scopes: [.openid, .profile], nonce: "<nonce>", codeChallenge: "<code_challenge>") { (result) in
            switch result {
            case .success(let loginResult):
                let alert = UIAlertController(title: "Authorization Code取得成功", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .failure(let error):
                let alert = UIAlertController(title: "Authorization Code取得失敗", message: "error = \(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: LoginButtonDelegate {
    func loginButtonDidStartLogin(_ button: LoginButton) {
        print("start")
    }

    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
        let alert = UIAlertController(title: "Authorization Code取得成功", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func loginButton(_ button: LoginButton, didFailLogin error: LoginError) {
        let alert = UIAlertController(title: "Authorization Code取得失敗", message: "error = \(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
