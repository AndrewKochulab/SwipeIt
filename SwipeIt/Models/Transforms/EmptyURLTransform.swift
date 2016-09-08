//
//  EmptyURLTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 25/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class EmptyURLTransform: TransformType {
  typealias Object = URL
  typealias JSON = String

  init() {}

  func transformFromJSON(_ value: AnyObject?) -> URL? {
    if let URLString = value as? String , URLString.characters.count > 0 {
      return URL(string: URLString)
    }
    return nil
  }

  func transformToJSON(_ value: URL?) -> String? {
    if let URL = value {
      return URL.absoluteString
    }
    return nil
  }
}
