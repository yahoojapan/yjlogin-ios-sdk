// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "YJLoginSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "YJLoginSDK", targets: ["YJLoginSDK"]),
    ],
    targets: [
        .target(
            name: "YJLoginSDK",
            path: "YJLoginSDK",
            exclude: [
                "Info.plist"
            ],
            resources: [
                .process("Assets.xcassets"),
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
