//
//  StubUserAgent.swift
//  YJLoginSDKTests
//
//  © 2019 LY Corporation. All rights reserved.
//

import Foundation
@testable import YJLoginSDK

internal struct StubUserAgent: UserAgent {
    private(set) var result: Result<URL, Error>

    func present(url: URL, callbackScheme: String, viewController: UIViewController?, completionHandler completion: @escaping (Result<URL, Error>) -> Void) {
        completion(result)
    }

    func dismiss() {
    }
}
