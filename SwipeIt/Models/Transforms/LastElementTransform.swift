//
//  LastElementTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 28/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class LastElementTransform<T: Mappable>: TransformType {
  typealias Object = T
  typealias JSON = [[String: AnyObject]]

  init() { }

  func transformFromJSON(_ value: AnyObject?) -> Object? {
    guard let value = value as? JSON else {
      return nil
    }
    return Mapper<Object>().map(value.last)
  }

  func transformToJSON(_ value: Object?) -> JSON? {
    guard let value = value else {
      return nil
    }
    return [Mapper<Object>().toJSON(value)]
  }
}
