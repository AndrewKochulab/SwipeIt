//
//  AlerteableViewController.swift
//  Reddit
//
//  Created by Ivan Bruel on 26/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

protocol AlerteableViewController {

  func presentAlert(title: String?, message: String?, textField: AlertTextField?,
                    buttonTitle: String?, cancelButtonTitle: String?,
                    alertClicked: ((AlertButtonClicked) -> Void)?)

  func presentActionSheet(title: String?, message: String?, options: [String],
                          clicked: (Int?) -> Void)

}

extension AlerteableViewController where Self: UIViewController {

  func presentAlert(title: String? = nil, message: String? = nil, textField: AlertTextField? = nil,
                    buttonTitle: String? = nil, cancelButtonTitle: String? = nil,
                    alertClicked: ((AlertButtonClicked) -> Void)? = nil) {

    let alertController = UIAlertController(title: title, message: message,
                                            preferredStyle: .Alert)

    if let cancelButtonTitle = cancelButtonTitle {
      let dismissAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { _ in
        alertClicked?(.Cancel)
      }
      alertController.addAction(dismissAction)
    }

    if let textFieldConfig = textField {
      alertController.addTextFieldWithConfigurationHandler { (textField) in
        textField.placeholder = textFieldConfig.placeholder
        textField.text = textFieldConfig.text

        if let buttonTitle = buttonTitle {
          let buttonAction = UIAlertAction(title: buttonTitle, style: .Default) { _ in
            alertClicked?(.ButtonWithText(textField.text))
          }
          alertController.addAction(buttonAction)
        }
      }
    } else {
      if let buttonTitle = buttonTitle {
        let buttonAction = UIAlertAction(title: buttonTitle, style: .Default) { _ in
          alertClicked?(.Button)
        }
        alertController.addAction(buttonAction)
      }
    }
    self.presentViewController(alertController, animated: true, completion: nil)
  }

  func presentActionSheet(title: String? = nil, message: String? = nil, options: [String],
                          clicked: (Int?) -> Void) {
    let alertController = UIAlertController(title: title, message: message,
                                            preferredStyle: .ActionSheet)

    let cancelAction = UIAlertAction(title: tr(.AlertButtonCancel), style: .Cancel) { action in
      clicked(nil)
    }
    alertController.addAction(cancelAction)

    (0..<options.count).forEach { index in
      let action = UIAlertAction(title: options[index], style: .Default) { action in
        clicked(index)
      }
      alertController.addAction(action)
    }

    self.presentViewController(alertController, animated: true, completion: nil)
  }
}

enum AlertButtonClicked {
  case Button
  case ButtonWithText(String?)
  case Cancel
}

func == (lhs: AlertButtonClicked, rhs: AlertButtonClicked) -> Bool {
  switch (lhs, rhs) {
  case (.Button, .Button):
    return true
  case (.ButtonWithText, .ButtonWithText):
    return true
  case (.Cancel, .Cancel):
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
