//
//  LoginButtonTests.swift
//  YJLoginSDKTests
//
//  © 2019 LY Corporation. All rights reserved.
//

import XCTest
@testable import YJLoginSDK

class LoginButtonTests: XCTestCase {
    override func setUp() {
        LoginManager.shared.setup(clientId: "client_id", redirectUri: URL(string: "scheme:/")!)
    }

    func test_login_success() {
        let vc = ViewController()
        vc.process = StubProcess(result: .success(LoginResult(authorizationCode: "code", state: "state")))
        vc.viewDidLoad()
        vc.button.sendActions(for: .touchUpInside)
        XCTAssertEqual(vc.startCount, 1)
        XCTAssertEqual(vc.succeedCount, 1)
        XCTAssertEqual(vc.failCount, 0)
    }

    func test_login_fail() {
        let vc = ViewController()
        vc.process = StubProcess(result: .failure(.userCancel))
        vc.viewDidLoad()
        vc.button.sendActions(for: .touchUpInside)
        XCTAssertEqual(vc.startCount, 1)
        XCTAssertEqual(vc.succeedCount, 0)
        XCTAssertEqual(vc.failCount, 1)
    }
}

private class ViewController: UIViewController {
    var button: LoginButton!
    var process: AuthenticationProcessProtocol!
    var startCount = 0
    var succeedCount = 0
    var failCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        button = LoginButton()
        button.nonce = "nonce"
        button.codeChallenge = "code_challenge"
        button.process = process
        view.addSubview(button)
        button.center = view.center
        button.delegate = self
    }
}

extension ViewController: LoginButtonDelegate {
    func loginButtonDidStartLogin(_ button: LoginButton) {
        startCount += 1
    }

    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
        succeedCount += 1
    }

    func loginButton(_ button: LoginButton, didFailLogin error: LoginError) {
        failCount += 1
    }
}
