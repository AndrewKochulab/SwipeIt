//
//  Edited.swift
//  Reddit
//
//  Created by Ivan Bruel on 07/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

enum Edited: Equatable {

  case `false`
  case `true`(editedAt: Date?)

  var editedAt: Date? {
    switch self {
    case .true(let date):
      return date
    default:
      return nil
    }
  }

  var value: AnyObject {
    switch self {
    case .false:
      return false
    case .true(let editedAt):
      guard let editedAt = editedAt else {
        return true
      }
      return Int(editedAt.timeIntervalSince1970)
    }
  }

  static func fromValue(_ value: AnyObject?) -> Edited {
    switch value {
    case let epochDate as Int:
      guard epochDate > 1 else {
        return epochDate == 0 ? .false : .true(editedAt: nil)
      }
      return .true(editedAt: (Date(timeIntervalSince1970: Double(epochDate))))
    case let edited as Bool:
      return edited ? .true(editedAt: nil) : .false
    default:
      return .false
    }
  }
}

func == (lhs: Edited, rhs: Edited) -> Bool {
  switch (lhs, rhs) {
  case (.false, .false):
    return true
  case (.false, .true), (.true, .false):
    return false
  case (.true(let lhsDate), .true(let rhsDate)):
    guard let lhsDateValue = lhsDate, let rhsDateValue = rhsDate else {
      return lhsDate == rhsDate
    }
    return lhsDateValue.compare(rhsDateValue) == .orderedSame
  }
}
