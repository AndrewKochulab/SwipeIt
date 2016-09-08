//
//  Theme.swift
//  Reddit
//
//  Created by Ivan Bruel on 06/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

enum Theme: String {
  case Light
  case Dark

  var textColor: UIColor {
    switch self {
    case .Light:
      return .darkText()
    case .Dark:
      return .lightText()
    }
  }

  var secondaryTextColor: UIColor {
    switch self {
    case .Light:
      return UIColor(named: .darkGray)
    case .Dark:
      return UIColor(named: .lightGray)
    }
  }

  var accentColor: UIColor {
    switch self {
    default:
      return UIColor(named: .iosBlue)
    }
  }

  var backgroundColor: UIColor {
    switch self {
    case .Light:
      return .white()
    case .Dark:
      return .darkGray()
    }
  }
}
