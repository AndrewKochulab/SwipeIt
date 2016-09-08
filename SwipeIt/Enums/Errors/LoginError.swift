//
//  LoginError.swift
//  Reddit
//
//  Created by Ivan Bruel on 26/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

// MARK: - Enum Values
enum LoginError: Error {

  /// User cancelled the login
  case userCancelled
  /// Any other error
  case unknown
}

// MARK: - Printable
extension LoginError: CustomStringConvertible {

  var description: String {
    switch self {
    case .userCancelled:
      return tr(.loginErrorUserCancelled)
    case .unknown:
      return tr(.loginErrorUnknown)
    }
  }
}
