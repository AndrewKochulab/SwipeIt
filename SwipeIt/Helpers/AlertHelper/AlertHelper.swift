//
//  AlertHelper.swift
//  Reddit
//
//  Created by Ivan Bruel on 05/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

class AlertHelper {

  fileprivate let viewController: UIViewController

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func presentActionSheet(title: String? = nil, message: String? = nil, options: [String],
                          clicked: @escaping (Int?) -> Void) {
    let alertController = UIAlertController(title: title, message: message,
                                            preferredStyle: .actionSheet)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
      clicked(nil)
    }
    alertController.addAction(cancelAction)

    (0..<options.count).forEach { index in
      let action = UIAlertAction(title: options[index], style: .default) { action in
        clicked(index)
      }
      alertController.addAction(action)
    }

    viewController.present(alertController, animated: true, completion: nil)
  }
}
