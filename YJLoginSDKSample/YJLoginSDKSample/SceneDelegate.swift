//
//  SceneDelegate.swift
//  YJLoginSDKSample
//
//  © 2026 LY Corporation. All rights reserved.
//

import UIKit
import YJLoginSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // swiftlint:disable:next force_unwrapping
        LoginManager.shared.setup(clientId: "<client_id>", redirectUri: URL(string: "<redirect_uri>")!)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }

        var options: [UIApplication.OpenURLOptionsKey: Any] = [
            .openInPlace: urlContext.options.openInPlace
        ]
        if let sourceApplication = urlContext.options.sourceApplication {
            options[.sourceApplication] = sourceApplication
        }
        if let annotation = urlContext.options.annotation {
            options[.annotation] = annotation
        }

        _ = LoginManager.shared.application(UIApplication.shared,
                                            open: urlContext.url,
                                            options: options)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        _ = LoginManager.shared.application(UIApplication.shared, open: userActivity.webpageURL)
    }
}
