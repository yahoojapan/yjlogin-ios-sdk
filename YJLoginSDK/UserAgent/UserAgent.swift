//
//  UserAgent.swift
//  YJLoginSDK
//
//  Copyright © LY Corporation. All rights reserved.
//

import Foundation
import AuthenticationServices
import SafariServices

internal protocol UserAgent {
    func present(url: URL, callbackScheme: String, viewController: UIViewController?, completionHandler completion: @escaping (Result<URL, Error>) -> Void)
    func dismiss()
}
