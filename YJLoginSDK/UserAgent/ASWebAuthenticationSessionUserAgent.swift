//
//  ASWebAuthenticationSessionUserAgent.swift
//  YJLoginSDK
//
//  © 2023 LY Corporation. All rights reserved.
//

import Foundation
import AuthenticationServices

@available(iOS 12.0, *)
internal class ASWebAuthenticationSessionUserAgent: NSObject, UserAgent {
    private var asWebAuthenticationSession: ASWebAuthenticationSession?
    internal func present(url: URL, callbackScheme: String, viewController: UIViewController?, completionHandler completion: @escaping (Result<URL, Error>) -> Void) {

        asWebAuthenticationSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackScheme, completionHandler: { url, error in
            if let url = url {
                completion(.success(url))
                return
            }

            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.failure(ASWebAuthenticationSessionUserAgentError.unexpected))
        })

        if #available(iOS 13.0, *) {
            asWebAuthenticationSession?.presentationContextProvider = self
        }
        asWebAuthenticationSession?.start()
    }

    internal func dismiss() {
        asWebAuthenticationSession?.cancel()
    }
}

enum ASWebAuthenticationSessionUserAgentError: Error {
    case unexpected
}

@available(iOS 13.0, *)
extension ASWebAuthenticationSessionUserAgent: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first ?? ASPresentationAnchor()
    }
}
