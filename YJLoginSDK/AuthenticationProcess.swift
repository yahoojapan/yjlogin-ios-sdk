//
//  AuthenticationProcess.swift
//  YJLoginSDK
//
//  Copyright © 2019 Yahoo Japan Corporation. All rights reserved.
//

import Foundation
import AuthenticationServices
import SafariServices

internal protocol AuthenticationProcessProtocol {
    var onFinish: ((Result<LoginResult, LoginError>) -> Void)? { get set }
    var viewController: UIViewController? { get set }
    func start(request: AuthenticationRequest)
    func resume(url: URL) -> Bool
}

internal class AuthenticationProcess: AuthenticationProcessProtocol {
    let ua: UserAgent
    var request: AuthenticationRequest?
    var onFinish: ((Result<LoginResult, LoginError>) -> Void)?
    weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        if #available(iOS 12.0, *) {
            ua = ASWebAuthenticationSessionUserAgent()
        } else if #available(iOS 11.0, *) {
            ua = SFAuthenticationSessionUserAgent()
        } else {
            ua = SFSafariViewControllerUserAgent()
        }
        self.viewController = viewController
    }

    init(ua: UserAgent) {
        self.ua = ua
    }

    private func convertLoginError(url: URL?, error: Error?) -> Result<LoginResult, LoginError> {
        if let error = error {
            if #available(iOS 12.0, *) {
                if case ASWebAuthenticationSessionError.canceledLogin = error {
                    return .failure(.userCancel)
                }
                return .failure(.undefinedError(error: error))
            }

            if #available(iOS 11.0, *) {
                if case SFAuthenticationError.canceledLogin.rawValue = (error as NSError).code {
                    return .failure(.userCancel)
                }
                return .failure(.undefinedError(error: error))
            }

            if case SFSafariViewControllerUserAgentError.userCancel = error {
                return .failure(.userCancel)
            }
            return .failure(.undefinedError(error: error))
        }

        guard let url = url else {
            return .failure(.undefinedError(error: nil))
        }

        do {
            let response = try AuthenticationResponse(url: url, validatingWith: request?.state)
            let result = LoginResult(authorizationCode: response.authorizationCode, state: response.state)
            return .success(result)
        } catch {
            guard let responseError = error as? AuthenticationResponseError else {
                return .failure(.undefinedError(error: error))
            }

            switch responseError {
            case .invalidState:
                return .failure(.responseFailed(.invalidState))

            case .userCancel, .emptyAuthorizationCode:
                return .failure(.userCancel)

            case .undefinedError(let error, let description, let code):
                let loginErrorDetailResponse = LoginError.DetailResponse(error: error, errorDescription: description, errorCode: code)
                return .failure(.responseFailed(.undefined(loginErrorDetailResponse)))

            case .unexpectedError:
                return .failure(.undefinedError(error: error))

            case .serverError(let error, let description, let code):
                let loginErrorDetailResponse = LoginError.DetailResponse(error: error.rawValue, errorDescription: description, errorCode: code)

                switch error {
                case .serverError:
                    return .failure(.systemError(.systemError(loginErrorDetailResponse)))

                case .consentRequired:
                    return .failure(.userInteractionRequired(.consentRequired(loginErrorDetailResponse)))

                case .loginRequired:
                    return .failure(.userInteractionRequired(.loginRequired(loginErrorDetailResponse)))

                case .interactionRequired:
                    return .failure(.userInteractionRequired(.interactionRequired(loginErrorDetailResponse)))

                case .accessDenied:
                    return .failure(.requestFailed(.accessDenied(loginErrorDetailResponse)))

                case .invalidScope:
                    return .failure(.requestFailed(.invalidScope(loginErrorDetailResponse)))

                case .invalidRequest:
                    return .failure(.requestFailed(.invalidRequest(loginErrorDetailResponse)))

                case .unsupportedResponseType:
                    return .failure(.requestFailed(.unsupportedResponseType(loginErrorDetailResponse)))
                }
            }
        }
    }

    func resume(url: URL) -> Bool {
        guard let request = request else {
            return false
        }

        guard request.redirectUri.scheme == url.scheme &&
                request.redirectUri.user == url.user &&
                request.redirectUri.password == url.password &&
                request.redirectUri.host == url.host &&
                request.redirectUri.port == url.port &&
                request.redirectUri.path == url.path else {
            return false
        }
        ua.dismiss()
        self.onFinish?(self.convertLoginError(url: url, error: nil))
        return true
    }

    func start(request: AuthenticationRequest) {
        self.request = request
        guard let url = request.requestUrl else {
            onFinish?(.failure(.undefinedError(error: nil)))
            return
        }

        ua.present(url: url, callbackScheme: request.redirectUri.absoluteString, viewController: viewController) { result in
            self.ua.dismiss()
            switch result {
            case .success(let url):
                self.onFinish?(self.convertLoginError(url: url, error: nil))
            case .failure(let error):
                self.onFinish?(self.convertLoginError(url: nil, error: error))
            }
        }
    }
}
