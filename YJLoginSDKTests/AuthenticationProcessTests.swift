//
//  AuthenticationProcessTests.swift
//  YJLoginSDKTests
//
//  © 2023 LY Corporation. All rights reserved.
//

import XCTest
import AuthenticationServices
import SafariServices
@testable import YJLoginSDK

class AuthenticationProcessTests: XCTestCase {
    var process: AuthenticationProcess?

    func test_normal() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state&code=code")!))

        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .success(let result) = result {
                XCTAssertEqual(result.authorizationCode, "code")
                XCTAssertEqual(result.state, "state")
                expect.fulfill()
            } else {
                XCTFail("The result should be success.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_user_cancel() {
        let error: Error!
        error = ASWebAuthenticationSessionError.init(.canceledLogin)

        let stub = StubUserAgent(result: .failure(error))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .userCancel = error {
                expect.fulfill()
            } else {
                XCTFail("The result should be fail.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_user_cancel_button() {
        let stub = StubUserAgent(result: .success(URL(string: "scheme:/?")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .userCancel = error {
                expect.fulfill()
            } else {
                XCTFail("The result should be fail.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_system_error() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state&error=server_error&error_description=hogehoge&error_code=1000")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .systemError(let reason) = error, case .systemError(let response) = reason {
                XCTAssertEqual(response.error, "server_error")
                XCTAssertEqual(response.errorDescription, "hogehoge")
                XCTAssertEqual(response.errorCode, 1000)
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with server_error.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 10.0)
    }

    func test_response_failed_invalid_state() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=invalid_state&code=code")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .responseFailed(let reason) = error, case .invalidState = reason {
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with invalid_state.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_response_failed_missing_state() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?code=code")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .responseFailed(let reason) = error, case .invalidState = reason {
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with invalid_state.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_response_failed_unnecessary_state() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?code=code&state=state")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: nil)

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .responseFailed(let reason) = error, case .invalidState = reason {
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with invalid_state.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_response_failed_undefined() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state&error=unexpected_error&error_description=hogehoge&error_code=1000")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .responseFailed(let reason) = error, case .undefined(let detail) = reason {
                XCTAssertEqual(detail.error, "unexpected_error")
                XCTAssertEqual(detail.errorDescription, "hogehoge")
                XCTAssertEqual(detail.errorCode, 1000)
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with undefined.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_response_failed_missing_authorization_code() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .userCancel = error {
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with missing_authorization_code.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_user_interaction_required_login_required() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state&error=login_required&error_description=hogehoge&error_code=1000")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .userInteractionRequired(let reason) = error, case .loginRequired(let detail) = reason {
                XCTAssertEqual(detail.error, "login_required")
                XCTAssertEqual(detail.errorDescription, "hogehoge")
                XCTAssertEqual(detail.errorCode, 1000)
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with login_required.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_user_interaction_required_consent_required() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state&error=consent_required&error_description=hogehoge&error_code=1000")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .userInteractionRequired(let reason) = error, case .consentRequired(let detail) = reason {
                XCTAssertEqual(detail.error, "consent_required")
                XCTAssertEqual(detail.errorDescription, "hogehoge")
                XCTAssertEqual(detail.errorCode, 1000)
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with consent_required.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_user_interaction_required_interaction_required() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state&error=interaction_required&error_description=hogehoge&error_code=1000")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .userInteractionRequired(let reason) = error, case .interactionRequired(let detail) = reason {
                XCTAssertEqual(detail.error, "interaction_required")
                XCTAssertEqual(detail.errorDescription, "hogehoge")
                XCTAssertEqual(detail.errorCode, 1000)
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with interaction_required.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_request_failed_access_denied() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state&error=access_denied&error_description=hogehoge&error_code=1000")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .requestFailed(let reason) = error, case .accessDenied(let detail) = reason {
                XCTAssertEqual(detail.error, "access_denied")
                XCTAssertEqual(detail.errorDescription, "hogehoge")
                XCTAssertEqual(detail.errorCode, 1000)
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with access_denied.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_request_failed_invalid_scope() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state&error=invalid_scope&error_description=hogehoge&error_code=1000")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .requestFailed(let reason) = error, case .invalidScope(let detail) = reason {
                XCTAssertEqual(detail.error, "invalid_scope")
                XCTAssertEqual(detail.errorDescription, "hogehoge")
                XCTAssertEqual(detail.errorCode, 1000)
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with invalid_scope.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_request_failed_invalid_request() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state&error=invalid_request&error_description=hogehoge&error_code=1000")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .requestFailed(let reason) = error, case .invalidRequest(let detail) = reason {
                XCTAssertEqual(detail.error, "invalid_request")
                XCTAssertEqual(detail.errorDescription, "hogehoge")
                XCTAssertEqual(detail.errorCode, 1000)
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with invalid_request.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_request_failed_unsupported_response_type() {
        let stub = StubUserAgent(result: .success(URL(string: "test:/?state=state&error=unsupported_response_type&error_description=hogehoge+hogehoge&error_code=1000")!))
        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .requestFailed(let reason) = error, case .unsupportedResponseType(let detail) = reason {
                XCTAssertEqual(detail.error, "unsupported_response_type")
                XCTAssertEqual(detail.errorDescription, "hogehoge hogehoge")
                XCTAssertEqual(detail.errorCode, 1000)
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with unsupported_response_type.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_undefined_error() {
        let expectedError = NSError(domain: "test", code: 0, userInfo: nil)
        let stub = StubUserAgent(result: .failure(expectedError))

        process = AuthenticationProcess(ua: stub)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")

        let expect = self.expectation(description: self.name)

        process?.onFinish = { result in
            if case .failure(let error) = result, case .undefinedError(let resultError) = error {
                XCTAssertNotNil(resultError)

                let actualError = resultError! as NSError
                XCTAssertEqual(expectedError.code, actualError.code)
                XCTAssertEqual(expectedError.domain, actualError.domain)
                expect.fulfill()
            } else {
                XCTFail("The result should be fail with undefined_error.")
            }
        }
        process?.start(request: request)
        self.wait(for: [expect], timeout: 2.0)
    }

    func test_resume_success() {
        process = AuthenticationProcess(viewController: nil)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")
        process?.start(request: request)
        XCTAssertTrue(process!.resume(url: URL(string: "scheme:/?")!))
    }

    func test_resume_request_null() {
        process = AuthenticationProcess(viewController: nil)
        XCTAssertFalse(process!.resume(url: URL(string: "scheme:/")!))
    }

    func test_resume_invalid_redirect_uri_scheme() {
        process = AuthenticationProcess(viewController: nil)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme:/?")!, responseType: .code, scopes: [.openid, .profile], state: "state")
        process?.start(request: request)
        XCTAssertFalse(process!.resume(url: URL(string: "invalidscheme:/")!))
    }

    func test_resume_invalid_redirect_path() {
        process = AuthenticationProcess(viewController: nil)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "scheme://path?")!, responseType: .code, scopes: [.openid, .profile], state: "state")
        process?.start(request: request)
        XCTAssertFalse(process!.resume(url: URL(string: "scheme://invalidpath")!))
    }

    func test_resume_invalid_redirect_user() {
        process = AuthenticationProcess(viewController: nil)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "https://user:passwd@host/path?")!, responseType: .code, scopes: [.openid, .profile], state: "state")
        process?.start(request: request)
        XCTAssertFalse(process!.resume(url: URL(string: "https://invaliduser:passwd@host/path")!))
    }

    func test_resume_invalid_redirect_password() {
        process = AuthenticationProcess(viewController: nil)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "https://user:passwd@host/path?")!, responseType: .code, scopes: [.openid, .profile], state: "state")
        process?.start(request: request)
        XCTAssertFalse(process!.resume(url: URL(string: "https://user:invalidpasswd@host/path")!))
    }

    func test_resume_invalid_redirect_port() {
        process = AuthenticationProcess(viewController: nil)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "https://host/path:8080?")!, responseType: .code, scopes: [.openid, .profile], state: "state")
        process?.start(request: request)
        XCTAssertFalse(process!.resume(url: URL(string: "https://host/path:0000")!))
    }

    func test_resume_invalid_redirect_host() {
        process = AuthenticationProcess(viewController: nil)
        let request = AuthenticationRequest(clientId: "client_id", codeChallenge: "code_challenge", nonce: "nonce", redirectUri: URL(string: "https://host/path:8080?")!, responseType: .code, scopes: [.openid, .profile], state: "state")
        process?.start(request: request)
        XCTAssertFalse(process!.resume(url: URL(string: "https://invalidhost/path:8080")!))
    }
}
