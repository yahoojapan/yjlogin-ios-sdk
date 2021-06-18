//
//  AuthenticationRequstTests.swift
//  YJLoginSDKTests
//
//  Copyright © 2019 Yahoo Japan Corporation. All rights reserved.
//
import XCTest
@testable import YJLoginSDK

class AuthenticationRequstTests: XCTestCase {
    func test_requestUri() {
        let request = AuthenticationRequest(
            clientId: "client_id",
            codeChallenge: "code_challenge",
            nonce: "nonce+nonce",
            redirectUri: URL(string: "scheme:/")!,
            responseType: .code,
            scopes: [.address, .email, .openid, .profile],
            state: "state"
        )

        XCTAssertNotNil(request.requestUrl)
        let component = URLComponents(url: request.requestUrl!, resolvingAgainstBaseURL: true)
        XCTAssertEqual(component?.scheme, "https")
        XCTAssertEqual(component?.host, "auth.login.yahoo.co.jp")
        XCTAssertEqual(component?.path, "/yconnect/v2/authorization")

        if #available(iOS 11.0, *) {
            XCTAssertEqual(component?.percentEncodedQueryItems, [
                URLQueryItem(name: "client_id", value: "client_id"),
                URLQueryItem(name: "code_challenge", value: "code_challenge"),
                URLQueryItem(name: "code_challenge_method", value: "S256"),
                URLQueryItem(name: "nonce", value: "nonce%2Bnonce"),
                URLQueryItem(name: "redirect_uri", value: "scheme:/"),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: "address%20email%20openid%20profile"),
                URLQueryItem(name: "state", value: "state"),
            ])
        } else {
            XCTAssertEqual(request.requestUrl, URL(string: "https://auth.login.yahoo.co.jp/yconnect/v2/authorization?client_id=client_id&nonce=nonce%2Bnonce&redirect_uri=scheme:/&response_type=code&scope=address%20email%20openid%20profile&state=state"))
        }
    }

    func test_requestUri_optional() {
        let optionalParameters = OptionalParameters(
            bail: true,
            display: .inapp,
            maxAge: 3600,
            prompts: [.login]
        )
        let request = AuthenticationRequest(
            clientId: "client_id",
            codeChallenge: "code_challenge",
            nonce: "nonce",
            redirectUri: URL(string: "scheme:/")!,
            responseType: .code,
            scopes: [.address, .email, .openid, .profile],
            state: "state",
            optionalParameter: optionalParameters
        )
        XCTAssertNotNil(request.requestUrl)
        let component = URLComponents(url: request.requestUrl!, resolvingAgainstBaseURL: true)
        XCTAssertEqual(component?.scheme, "https")
        XCTAssertEqual(component?.host, "auth.login.yahoo.co.jp")
        XCTAssertEqual(component?.path, "/yconnect/v2/authorization")

        if #available(iOS 11.0, *) {
            XCTAssertEqual(component?.percentEncodedQueryItems, [
                URLQueryItem(name: "bail", value: "1"),
                URLQueryItem(name: "client_id", value: "client_id"),
                URLQueryItem(name: "code_challenge", value: "code_challenge"),
                URLQueryItem(name: "code_challenge_method", value: "S256"),
                URLQueryItem(name: "display", value: "inapp"),
                URLQueryItem(name: "max_age", value: "3600"),
                URLQueryItem(name: "nonce", value: "nonce"),
                URLQueryItem(name: "prompt", value: "login"),
                URLQueryItem(name: "redirect_uri", value: "scheme:/"),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: "address%20email%20openid%20profile"),
                URLQueryItem(name: "state", value: "state")
            ])
        } else {
            XCTAssertEqual(request.requestUrl, URL(string: "https://auth.login.yahoo.co.jp/yconnect/v2/authorization?bail=1&client_id=client_id&display=inapp&max_age=3600&nonce=nonce&prompt=login&redirect_uri=scheme:/&response_type=code&scope=address%20email%20openid%20profile&state=state"))
        }
    }

    func test_requestUri_optional_additional() {
        let optionalParameters = OptionalParameters(
            bail: true,
            display: .inapp,
            maxAge: 3600,
            prompts: [.login],
            additionalParameters: ["string": "string", "int": "1"]
        )
        let request = AuthenticationRequest(
            clientId: "client_id",
            codeChallenge: "code_challenge",
            nonce: "nonce",
            redirectUri: URL(string: "scheme:/")!,
            responseType: .code,
            scopes: [.address, .email, .openid, .profile],
            state: "state",
            optionalParameter: optionalParameters
        )
        XCTAssertNotNil(request.requestUrl)
        let component = URLComponents(url: request.requestUrl!, resolvingAgainstBaseURL: true)
        XCTAssertEqual(component?.scheme, "https")
        XCTAssertEqual(component?.host, "auth.login.yahoo.co.jp")
        XCTAssertEqual(component?.path, "/yconnect/v2/authorization")

        if #available(iOS 11.0, *) {
            XCTAssertEqual(component?.percentEncodedQueryItems, [
                URLQueryItem(name: "bail", value: "1"),
                URLQueryItem(name: "client_id", value: "client_id"),
                URLQueryItem(name: "code_challenge", value: "code_challenge"),
                URLQueryItem(name: "code_challenge_method", value: "S256"),
                URLQueryItem(name: "display", value: "inapp"),
                URLQueryItem(name: "int", value: "1"),
                URLQueryItem(name: "max_age", value: "3600"),
                URLQueryItem(name: "nonce", value: "nonce"),
                URLQueryItem(name: "prompt", value: "login"),
                URLQueryItem(name: "redirect_uri", value: "scheme:/"),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: "address%20email%20openid%20profile"),
                URLQueryItem(name: "state", value: "state"),
                URLQueryItem(name: "string", value: "string")
            ])
        } else {
            XCTAssertEqual(request.requestUrl, URL(string: "https://auth.login.yahoo.co.jp/yconnect/v2/authorization?bail=1&client_id=client_id&display=inapp&int=1&max_age=3600&nonce=nonce&prompt=login&redirect_uri=scheme:/&response_type=code&scope=address%20email%20openid%20profile&state=state&string=string"))
        }
    }

    func test_requestUri_optional_additional_dupulicate() {
        let additionalParameters = [
            "bail": "0",
            "client_id": "duplicate_client_id",
            "code_challenge": "duplicate_code_challenge",
            "code_challenge_method": "duplicate_code_challenge_method",
            "display": "duplicate_display",
            "max_age": "1000",
            "nonce": "duplicated_nonce",
            "prompt": "duplicated_prompt",
            "redirect_uri": "duplicatescheme:/",
            "response_type": "duplicate_response_type",
            "scope": "duplicated_scope",
            "state": "duplicated_state",
        ]
        let optionalParameters = OptionalParameters(
            bail: true,
            display: .inapp,
            maxAge: 3600,
            prompts: [.consent],
            additionalParameters: additionalParameters
        )

        let request = AuthenticationRequest(
            clientId: "client_id",
            codeChallenge: "code_challenge",
            nonce: "nonce",
            redirectUri: URL(string: "scheme:/")!,
            responseType: .code,
            scopes: [.address, .email, .openid, .profile],
            state: "state",
            optionalParameter: optionalParameters
        )

        XCTAssertNotNil(request.requestUrl)
        let component = URLComponents(url: request.requestUrl!, resolvingAgainstBaseURL: true)
        XCTAssertEqual(component?.scheme, "https")
        XCTAssertEqual(component?.host, "auth.login.yahoo.co.jp")
        XCTAssertEqual(component?.path, "/yconnect/v2/authorization")

        if #available(iOS 11.0, *) {
            XCTAssertEqual(component?.percentEncodedQueryItems, URLComponents.dictionaryToQueryItem(dic: additionalParameters))
        } else {
            XCTAssertEqual(request.requestUrl, URL(string: "https://auth.login.yahoo.co.jp/yconnect/v2/authorization?bail=0&client_id=duplicate_client_id&display=duplicate_display&max_age=1000&nonce=duplicated_nonce&prompt=duplicated_prompt&redirect_uri=duplicatescheme:/&response_type=duplicate_response_type&scope=duplicated_scope&state=duplicated_state"))
        }
    }

    func test_requestUri_multiple_prompts() {
        let optionalParameters = OptionalParameters(
            bail: true,
            display: .inapp,
            maxAge: 3600,
            prompts: [.login, .consent]
        )

        let request = AuthenticationRequest(
            clientId: "client_id",
            codeChallenge: "code_challenge",
            nonce: "nonce",
            redirectUri: URL(string: "scheme:/")!,
            responseType: .code,
            scopes: [.address, .email, .openid, .profile],
            state: "state",
            optionalParameter: optionalParameters
        )
        XCTAssertNotNil(request.requestUrl)
        let component = URLComponents(url: request.requestUrl!, resolvingAgainstBaseURL: true)
        XCTAssertEqual(component?.scheme, "https")
        XCTAssertEqual(component?.host, "auth.login.yahoo.co.jp")
        XCTAssertEqual(component?.path, "/yconnect/v2/authorization")

        if #available(iOS 11.0, *) {
            XCTAssertEqual(component?.percentEncodedQueryItems, [
                URLQueryItem(name: "bail", value: "1"),
                URLQueryItem(name: "client_id", value: "client_id"),
                URLQueryItem(name: "code_challenge", value: "code_challenge"),
                URLQueryItem(name: "code_challenge_method", value: "S256"),
                URLQueryItem(name: "display", value: "inapp"),
                URLQueryItem(name: "max_age", value: "3600"),
                URLQueryItem(name: "nonce", value: "nonce"),
                URLQueryItem(name: "prompt", value: "login%20consent"),
                URLQueryItem(name: "redirect_uri", value: "scheme:/"),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: "address%20email%20openid%20profile"),
                URLQueryItem(name: "state", value: "state"),
            ])
        } else {
            XCTAssertEqual(request.requestUrl, URL(string: "https://auth.login.yahoo.co.jp/yconnect/v2/authorization?bail=1&client_id=client_id&display=inapp&max_age=3600&nonce=nonce&prompt=login%20consent&redirect_uri=scheme:/&response_type=code&scope=address%20email%20openid%20profile&state=state"))
        }
    }

    func test_requestUri_issuer() {
        let optionalParameters = OptionalParameters(
            bail: true,
            display: .inapp,
            maxAge: 3600,
            prompts: [.login, .consent]
        )

        let request = AuthenticationRequest(
            clientId: "client_id",
            codeChallenge: "code_challenge",
            nonce: "nonce",
            redirectUri: URL(string: "scheme:/")!,
            responseType: .code,
            scopes: [.address, .email, .openid, .profile],
            state: "state",
            optionalParameter: optionalParameters,
            issuer: URL(string: "https://hoge.yahoo.co.jp/yconnect/v2")!
        )

        XCTAssertNotNil(request.requestUrl)
        let component = URLComponents(url: request.requestUrl!, resolvingAgainstBaseURL: true)
        XCTAssertEqual(component?.scheme, "https")
        XCTAssertEqual(component?.host, "hoge.yahoo.co.jp")
        XCTAssertEqual(component?.path, "/yconnect/v2/authorization")

        if #available(iOS 11.0, *) {
            XCTAssertEqual(component?.percentEncodedQueryItems, [
                URLQueryItem(name: "bail", value: "1"),
                URLQueryItem(name: "client_id", value: "client_id"),
                URLQueryItem(name: "code_challenge", value: "code_challenge"),
                URLQueryItem(name: "code_challenge_method", value: "S256"),
                URLQueryItem(name: "display", value: "inapp"),
                URLQueryItem(name: "max_age", value: "3600"),
                URLQueryItem(name: "nonce", value: "nonce"),
                URLQueryItem(name: "prompt", value: "login%20consent"),
                URLQueryItem(name: "redirect_uri", value: "scheme:/"),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: "address%20email%20openid%20profile"),
                URLQueryItem(name: "state", value: "state"),
            ])
        } else {
            XCTAssertEqual(request.requestUrl, URL(string: "https://auth.login.yahoo.co.jp/yconnect/v2/authorization?bail=1&client_id=client_id&display=inapp&max_age=3600&nonce=nonce&prompt=login%20consent&redirect_uri=scheme:/&response_type=code&scope=address%20email%20openid%20profile&state=state"))
        }
    }
}
