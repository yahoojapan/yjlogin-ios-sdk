//
//  Data+base64url.swift
//  YJLoginSDK
//
//  © 2019 LY Corporation. All rights reserved.
//

import Foundation

internal extension Data {
    func base64urlEncodedString() -> String {
        self.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
