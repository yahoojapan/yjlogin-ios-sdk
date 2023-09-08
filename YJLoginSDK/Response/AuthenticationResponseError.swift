//
//  AuthenticationResponseError.swift
//  YJLoginSDK
//
//  Copyright © LY Corporation. All rights reserved.
//

import Foundation

internal enum AuthenticationResponseError: Error {
    case userCancel
    case invalidState
    case emptyAuthorizationCode
    case unexpectedError
    case undefinedError(error: String, description: String, code: Int)
    case serverError(error: Error, description: String, code: Int)

    enum Error: String, CaseIterable {
        case accessDenied = "access_denied"
        case consentRequired = "consent_required"
        case interactionRequired = "interaction_required"
        case invalidRequest = "invalid_request"
        case invalidScope = "invalid_scope"
        case loginRequired = "login_required"
        case serverError = "server_error"
        case unsupportedResponseType = "unsupported_response_type"
    }

    struct DetailResponse {
        let error: String
        let errorDescription: String
        let errorCode: Int
    }
}
