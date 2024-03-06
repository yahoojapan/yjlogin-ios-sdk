//
//  AuthenticationProcess.swift
//  YJLoginSDK
//
//  © 2023 LY Corporation. All rights reserved.
//

import Foundation
import AuthenticationServices
import SafariServices

internal protocol AuthenticationProcessProtocol {
    var onFinish: ((Result<LoginResult, LoginError>) -> Void)? { get set }
    var viewController: UIViewController? { get set }
    func start(request: AuthenticationRequest)
    func resume(url: URL) -> Bool
    func setEnableUniversalLinks(enableUniversalLinks: Bool)
}

internal class AuthenticationProcess: AuthenticationProcessProtocol {
    let ua: UserAgent
    var request: AuthenticationRequest?
    var onFinish: ((Result<LoginResult, LoginError>) -> Void)?
    weak var viewController: UIViewController?
    var enableUniversalLinks: Bool = true

    init(viewController: UIViewController?) {
        ua = ASWebAuthenticationSessionUserAgent()
        self.viewController = viewController
    }

    init(ua: UserAgent) {
        self.ua = ua
    }

    private func convertLoginError(url: URL?, error: Error?) -> Result<LoginResult, LoginError> {
        if let error {
            if case ASWebAuthenticationSessionError.canceledLogin = error {
                return .failure(.userCancel)
            }
            return .failure(.undefinedError(error: error))
        }

        guard let url else {
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

    private func presentUserAgent(url: URL, scheme: String) {
        self.ua.present(url: url, callbackScheme: scheme, viewController: viewController) { result in
            self.ua.dismiss()
            switch result {
            case .success(let url):
                self.onFinish?(self.convertLoginError(url: url, error: nil))
            case .failure(let error):
                self.onFinish?(self.convertLoginError(url: nil, error: error))
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
        guard let url = request.requestUrl,
              let scheme = request.requestUrl?.scheme else {
            onFinish?(.failure(.undefinedError(error: nil)))
            return
        }

        if self.enableUniversalLinks {
            var appAuthRequest = request
            appAuthRequest.path = Constant.appAuthPath

            guard let appauthUrl = appAuthRequest.requestUrl else {
                onFinish?(.failure(.undefinedError(error: nil)))
                return
            }

            UIApplication.shared.open(appauthUrl, options: [.universalLinksOnly: true]) { isOpened in
                if !isOpened {
                    self.presentUserAgent(url: url, scheme: scheme)
                }
            }
            return
        }

        self.presentUserAgent(url: url, scheme: scheme)
    }

    func setEnableUniversalLinks(enableUniversalLinks: Bool) {
        self.enableUniversalLinks = enableUniversalLinks
    }
}
