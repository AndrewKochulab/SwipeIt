//
//  HTMLEncodingTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 08/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class HTMLEncodingTransform: TransformType {
  typealias Object = String
  typealias JSON = String

  init() {}

  func transformFromJSON(_ value: AnyObject?) -> Object? {
    guard let value = value as? String else {
      return nil
    }
    return value.stringByDecodingHTMLEntities
  }

  func transformToJSON(_ value: Object?) -> String? {
    return value
  }
}
