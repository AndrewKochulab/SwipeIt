//
//  Likes.swift
//  Reddit
//
//  Created by Ivan Bruel on 04/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

enum Vote: Int {

  case upvote = 1
  case downvote = -1
  case none = 0

  var value: Bool? {
    switch self {
    case .upvote:
      return true
    case .downvote:
      return false
    case .none:
      return nil
    }
  }

  static func fromBool(_ bool: Bool?) -> Vote {
    guard let bool = bool else {
      return .none
    }
    return bool ? .upvote : .downvote
  }

}
