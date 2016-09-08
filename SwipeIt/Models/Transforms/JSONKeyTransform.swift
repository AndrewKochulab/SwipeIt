//
//  JSONKeyTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 28/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class JSONKeyTransform: TransformType {
  typealias Object = [String]
  typealias JSON = [[String: String]]

  fileprivate let key: String

  init(_ key: String) {
    self.key = key
  }

  func transformFromJSON(_ value: AnyObject?) -> Object? {
    guard let value = value as? JSON else {
      return nil
    }
    return value.flatMap { $0[self.key] }
  }

  func transformToJSON(_ value: Object?) -> JSON? {
    return value?.map { [self.key: $0] }
  }
}
