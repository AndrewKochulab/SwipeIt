//
//  ShareHelper.swift
//  Reddit
//
//  Created by Ivan Bruel on 09/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

class ShareHelper {

  fileprivate weak var viewController: UIViewController?

  init(viewController: UIViewController) {
    self.viewController = viewController
  }


  func share(_ text: String? = nil, URL: URL? = nil, image: UIImage? = nil,
             fromView: UIView? = nil) {
    let shareables: [AnyObject?] = [text, URL, image]

    let activityViewController = UIActivityViewController(activityItems: shareables.flatMap { $0 },
                                                          applicationActivities: nil)

    activityViewController.excludedActivityTypes = [UIActivityType.airDrop,
                                                    UIActivityType.openInIBooks]

    activityViewController.popoverPresentationController?.sourceView = fromView
    viewController?.present(activityViewController, animated: true, completion: nil)
  }
}
