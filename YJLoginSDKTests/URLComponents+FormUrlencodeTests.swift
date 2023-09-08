//
//  URLComponents+FormUrlencodeTests.swift
//  YJLoginSDKTests
//
//  Copyright © LY Corporation. All rights reserved.
//

import XCTest
@testable import YJLoginSDK

class URLComponentsFormUrlencodeTests: XCTestCase {

    func test_formUrlencodedUrl() {
        var urlComponent = URLComponents()
        urlComponent.queryItems = [
            URLQueryItem(name: "key", value: " %&+£€"),
        ]

        XCTAssertEqual(urlComponent.formUrlencodedUrl, URL(string: "?key=%20%25%26%2B%C2%A3%E2%82%AC"))
    }

    func test_formUrlencodedUrl_nil() {
        let urlComponent = URLComponents()
        XCTAssertNil(urlComponent.formUrlencodedUrl)
    }

    func test_init() {
        let urlComponent = URLComponents(formUrlencodedString: "?key=+%25%26%2B%C2%A3%E2%82%AC")
        for queryItem in urlComponent!.queryItems! {
            if queryItem.name == "key" {
                XCTAssertEqual(queryItem.value, " %&+£€")
            }
        }
    }

    func test_init_percent20() {
        let urlComponent = URLComponents(formUrlencodedString: "?key=test%20test")
        for queryItem in urlComponent!.queryItems! {
            if queryItem.name == "key" {
                XCTAssertEqual(queryItem.value, "test test")
            }
        }
    }

    func test_dictionaryToQueryItem() {
        let params: [String: String] = [
            "key2": "value2",
            "key1": "value1",
        ]
        XCTAssertEqual(
            URLComponents.dictionaryToQueryItem(dic: params),
            [URLQueryItem(name: "key1", value: "value1"), URLQueryItem(name: "key2", value: "value2")]
        )

    }
}
