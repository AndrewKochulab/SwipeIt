//
//  ZeroDefaultTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 27/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class ZeroDefaultTransform: TransformType {
  typealias Object = Int
  typealias JSON = Int

  init() {}

  func transformFromJSON(_ value: AnyObject?) -> Object? {
    guard let value = value as? Int else {
      return 0
    }
    return value
  }

  func transformToJSON(_ value: Object?) -> Int? {
    return value
  }
}
