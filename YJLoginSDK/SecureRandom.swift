//
//  SecureRandom.swift
//  YJLoginSDK
//
//  © 2023 LY Corporation. All rights reserved.
//

import Foundation

internal enum SecureRandomError: Error {
    case generate
}

internal struct SecureRandom {
    static func data(count: Int) throws -> Data {
        var bytes = [Int8].init(repeating: 0, count: count)
        guard SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes) == errSecSuccess else {
            throw SecureRandomError.generate
        }

        return Data(bytes: bytes, count: bytes.count)
    }
}
