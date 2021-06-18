Pod::Spec.new do |spec|
  spec.name = "YJLoginSDK"
  spec.version = "1.1.0"
  spec.summary = "The official OpenID Connect iOS client library for Yahoo! JAPAN."

  spec.homepage = "https://developer.yahoo.co.jp/yconnect/v2/client_app/ios/swift/"
  spec.license = { :type => "Apache License, Version 2.0", :file => "LICENSE.txt" }
  spec.author = "Yahoo Japan Corporation"

  spec.platform = :ios, "10.0"
  spec.swift_version = "5.0"

  spec.source = { :git => "https://github.com/yahoojapan/yjlogin-ios-sdk.git", :tag => "#{spec.version}" }
  spec.source_files = "YJLoginSDK/YJLoginSDK.h", "YJLoginSDK/**/*.swift"
  spec.resource = "YJLoginSDK/Assets.xcassets"

end
