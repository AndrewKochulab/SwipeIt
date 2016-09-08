//
//  AlerteableViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 26/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import RxSwift

protocol AlerteableViewController {

  func presentAlert(title: String?,
                    message: String?,
                    textField: AlertTextField?,
                    buttonTitle: String?,
                    cancelButtonTitle: String?,
                    alertClicked: ((AlertButtonClicked) -> Void)?)

}

extension AlerteableViewController where Self: UIViewController {

  func presentAlert(title: String? = nil,
                    message: String? = nil,
                    textField: AlertTextField? = nil,
                    buttonTitle: String? = nil,
                    cancelButtonTitle: String? = nil,
                    alertClicked: ((AlertButtonClicked) -> Void)? = nil) {

    let alertController = UIAlertController(title: title, message: message,
                                            preferredStyle: .alert)

    if let cancelButtonTitle = cancelButtonTitle {
      let dismissAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
        alertClicked?(.cancel)
      }
      alertController.addAction(dismissAction)
    }

    if let textFieldConfig = textField {
      alertController.addTextField { textField in
        textField.placeholder = textFieldConfig.placeholder
        textField.text = textFieldConfig.text

        if let buttonTitle = buttonTitle {
          let buttonAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            alertClicked?(.buttonWithText(textField.text))
          }
          alertController.addAction(buttonAction)
        }
      }
    } else {
      if let buttonTitle = buttonTitle {
        let buttonAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
          alertClicked?(.button)
        }
        alertController.addAction(buttonAction)
      }
    }
    self.present(alertController, animated: true, completion: nil)
  }
}

enum AlertButtonClicked {
  case button
  case buttonWithText(String?)
  case cancel
}

func == (lhs: AlertButtonClicked, rhs: AlertButtonClicked) -> Bool {
  switch (lhs, rhs) {
  case (.button, .button):
    return true
  case (.buttonWithText, .buttonWithText):
    return true
  case (.cancel, .cancel):
    return true
  default:
    return false
  }
}

struct AlertTextField {
  let text: String?
  let placeholder: String?

  init(text: String?, placeholder: String?) {
    self.text = text
    self.placeholder = placeholder
  }
}
