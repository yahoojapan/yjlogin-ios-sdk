//
//  LoginManagetTest.swift
//  YJLoginSDKTests
//
//  © 2023 LY Corporation. All rights reserved.
//

import XCTest
@testable import YJLoginSDK

class LoginManagetTests: XCTestCase {
    override func setUp() {
        LoginManager.shared.setup(clientId: "client_id", redirectUri: URL(string: "scheme:/")!)
    }

    func test_login_success() {
        let stubProcess = StubProcess(result: .success(LoginResult(authorizationCode: "abc", state: nil)))
        let expect = self.expectation(description: self.name)

        LoginManager.shared.login(scopes: [.openid], nonce: "nonce", codeChallenge: "code_challenge", process: stubProcess) { result in
            let result = try! result.get()
            XCTAssertEqual(result.authorizationCode, "abc")
            expect.fulfill()
        }

        self.wait(for: [expect], timeout: 2.0)
    }

    func test_login_optional_parameter_success() {
        let stubProcess = StubProcess(result: .success(LoginResult(authorizationCode: "abc", state: "state")))
        let expect = self.expectation(description: self.name)
        let optionalParameters = OptionalParameters(bail: true)
        LoginManager.shared.login(scopes: [.openid], nonce: "nonce", codeChallenge: "code_challenge", process: stubProcess, optionalParameters: optionalParameters) { result in
            let result = try! result.get()
            XCTAssertEqual(result.authorizationCode, "abc")
            XCTAssertEqual(result.state, "state")
            expect.fulfill()
        }
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_login_error() {
        let stubProcess = StubProcess(result: .failure(.userCancel))
        let expect = self.expectation(description: self.name)

        LoginManager.shared.login(scopes: [.openid], nonce: "nonce", codeChallenge: "code_chalenge", process: stubProcess) { result in
            if case .failure(let error) = result, case LoginError.userCancel = error {
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with user_cancel.")
            }
        }

        self.wait(for: [expect], timeout: 2.0)
    }

    func test_login_concurrent_with_disable_universal_links() {
        LoginManager.shared.setEnableUniversalLinks(enableUniversalLinks: false)
        let stubProcess = StubProcess(result: .success(LoginResult(authorizationCode: "abc", state: nil)))
        let expect = self.expectation(description: self.name)
        let stubProcess2 = StubProcess(result: .success(LoginResult(authorizationCode: "abc", state: nil)))
        let expect2 = self.expectation(description: self.name)

        DispatchQueue.global().async {
            LoginManager.shared.login(scopes: [.openid], nonce: "nonce", codeChallenge: "code_challenge", process: stubProcess) { result in
                let result = try! result.get()
                XCTAssertEqual(result.authorizationCode, "abc")
                expect.fulfill()
            }
        }

        usleep(100_000)

        DispatchQueue.global().async {
            LoginManager.shared.login(scopes: [.openid], nonce: "nonce", codeChallenge: "code_challenge",  process: stubProcess2) { result in
                if case .failure(let error) = result, case LoginError.authenticating = error {
                    expect2.fulfill()
                } else {
                    XCTFail("The result should be fail with authenticating.")
                }
            }
        }

        self.wait(for: [expect, expect2], timeout: 2.0)
    }

    func test_login_concurrent_with_enable_universal_links() {
        LoginManager.shared.setEnableUniversalLinks(enableUniversalLinks: true)
        let stubProcess = StubProcess(result: .success(LoginResult(authorizationCode: "abc", state: nil)))
        let expect = self.expectation(description: self.name)
        let stubProcess2 = StubProcess(result: .success(LoginResult(authorizationCode: "abc", state: nil)))
        let expect2 = self.expectation(description: self.name)

        DispatchQueue.global().async {
            LoginManager.shared.login(scopes: [.openid], nonce: "nonce", codeChallenge: "code_challenge", process: stubProcess) { result in
                let result = try! result.get()
                XCTAssertEqual(result.authorizationCode, "abc")
                expect.fulfill()
            }
        }

        usleep(100_000)

        DispatchQueue.global().async {
            LoginManager.shared.login(scopes: [.openid], nonce: "nonce", codeChallenge: "code_challenge", process: stubProcess2) { result in
                let result = try! result.get()
                XCTAssertEqual(result.authorizationCode, "abc")
                expect2.fulfill()
            }
        }

        self.wait(for: [expect, expect2], timeout: 2.0)
    }
}
