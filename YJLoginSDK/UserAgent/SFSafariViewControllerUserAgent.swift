//
//  SFSafariViewControllerUserAgent.swift
//  YJLoginSDK
//
//  © 2019 LY Corporation. All rights reserved.
//

import Foundation
import SafariServices

internal class SFSafariViewControllerUserAgent: NSObject, UserAgent {
    private var sfSafariViewController: SFSafariViewController?
    private var completion: ((Result<URL, Error>) -> Void)?

    internal func present(url: URL, callbackScheme: String, viewController: UIViewController?, completionHandler completion: @escaping (Result<URL, Error>) -> Void) {
        let sfSafariViewController = SFSafariViewController(url: url)
        sfSafariViewController.delegate = self
        self.sfSafariViewController  = sfSafariViewController

        self.completion = completion
        if let viewController = viewController {
            viewController.present(sfSafariViewController, animated: true)
        }
        var topController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController

        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }

        topController?.present(sfSafariViewController, animated: true)
    }

    internal func dismiss() {
        sfSafariViewController?.dismiss(animated: true, completion: nil)
    }
}

extension SFSafariViewControllerUserAgent: SFSafariViewControllerDelegate {
    internal func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        completion?(.failure(SFSafariViewControllerUserAgentError.userCancel))
    }
}

internal enum SFSafariViewControllerUserAgentError: Error {
    case userCancel
}
