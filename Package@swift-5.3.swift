// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YJLoginSDK",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "YJLoginSDK", targets: ["YJLoginSDK"])
    ],
    targets: [
        .target(
            name: "YJLoginSDK",
            path: "YJLoginSDK",
            exclude: [
                "Info.plist"
            ]
        )
    ]
)
