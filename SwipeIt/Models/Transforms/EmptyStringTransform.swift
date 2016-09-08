//
//  EmptyStringTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 25/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class EmptyStringTransform: TransformType {
  typealias Object = String
  typealias JSON = String

  init() {}

  func transformFromJSON(_ value: AnyObject?) -> Object? {
    guard let string = value as? String, string.characters.count > 0 else {
      return nil
    }
    return string
  }

  func transformToJSON(_ value: Object?) -> JSON? {
    return value
  }
}
