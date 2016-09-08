//
//  NilBoolTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 27/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class NilBoolTransform: TransformType {
  typealias Object = Bool
  typealias JSON = Bool

  init() {}

  func transformFromJSON(_ value: AnyObject?) -> Object? {
    guard let value = value as? Object else {
      return false
    }
    return value
  }

  func transformToJSON(_ value: Object?) -> JSON? {
    return value
  }
}
