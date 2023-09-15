//
//  SFAuthenticationSessionUserAgent.swift
//  YJLoginSDK
//
//  © 2019 LY Corporation. All rights reserved.
//

import Foundation
import SafariServices

@available(iOS 11.0, *)
internal class SFAuthenticationSessionUserAgent: UserAgent {
    private var sfAuthenticationSession: SFAuthenticationSession?
    internal func present(url: URL, callbackScheme: String, viewController: UIViewController?, completionHandler completion: @escaping (Result<URL, Error>) -> Void) {

        sfAuthenticationSession = SFAuthenticationSession(url: url, callbackURLScheme: callbackScheme, completionHandler: { url, error in
            if let url = url {
                completion(.success(url))
                return
            }

            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.failure(SFAuthenticationSessionUserAgentError.unexpected))
        })

        sfAuthenticationSession?.start()
    }
    internal func dismiss() {
        sfAuthenticationSession?.cancel()
    }
}

enum SFAuthenticationSessionUserAgentError: Error {
    case unexpected
}
