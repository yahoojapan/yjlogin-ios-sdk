//
//  AppDelegate.swift
//  YJLoginSDKSample
//
//  © 2023 LY Corporation. All rights reserved.
//

import UIKit
import YJLoginSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // swiftlint:disable:next force_unwrapping
        LoginManager.shared.setup(clientId: "<client_id>", redirectUri: URL(string: "<redirect_uri>")!)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        LoginManager.shared.application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        LoginManager.shared.application(application, open: userActivity.webpageURL)
    }
}
