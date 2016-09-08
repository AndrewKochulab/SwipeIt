//
//  PathTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 07/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class PathTransform: TransformType {
  typealias Object = String
  typealias JSON = String

  init() {}

  func transformFromJSON(_ value: AnyObject?) -> Object? {
    guard let value = value as? String else {
      return nil
    }
    return "\(value)/"
  }

  func transformToJSON(_ value: Object?) -> String? {
    return value
  }
}
