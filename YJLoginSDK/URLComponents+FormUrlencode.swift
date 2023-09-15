//
//  URLComponents+FormUrlencode.swift
//  YJLoginSDK
//
//  © 2019 LY Corporation. All rights reserved.
//

import Foundation

internal extension URLComponents {
    var formUrlencodedUrl: URL? {
        guard let url = url else { return nil }
        return URL(string: url.absoluteString.replacingOccurrences(of: "+", with: "%2B"))
    }

    init?(formUrlencodedString: String) {
        self.init(string: formUrlencodedString.replacingOccurrences(of: "+", with: "%20").replacingOccurrences(of: "%2B", with: "+"))
    }

    static func dictionaryToQueryItem(dic: [String: String]) -> [URLQueryItem] {
        return dic.map {
            return URLQueryItem(name: $0, value: $1)
        }.sorted(by: {$0.name < $1.name})
    }
}
