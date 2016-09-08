//
//  PermalinkTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 27/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class PermalinkTransform: TransformType {
  typealias Object = URL
  typealias JSON = String

  init() {}

  func transformFromJSON(_ value: AnyObject?) -> Object? {
    guard let value = value as? String else {
      return nil
    }
    let fullPermalink = "\(Constants.redditURL)\(value)"
    return URL(string: fullPermalink)
  }

  func transformToJSON(_ value: Object?) -> String? {
    return value?.absoluteString
  }
}
