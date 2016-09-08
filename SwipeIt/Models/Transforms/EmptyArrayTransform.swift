//
//  EmptyArrayTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 25/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class EmptyArrayTransform: TransformType {
  typealias Object = [String]
  typealias JSON = [String]

  init() {}

  func transformFromJSON(_ value: AnyObject?) -> Object? {
    guard let array = value as? [String], array.count > 0 else {
      return nil
    }
    return array
  }

  func transformToJSON(_ value: Object?) -> JSON? {
    return value
  }
}
