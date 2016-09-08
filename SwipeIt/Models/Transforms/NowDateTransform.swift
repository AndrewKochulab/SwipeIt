//
//  NowDateTransform.swift
//  Reddit
//
//  Created by Ivan Bruel on 26/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

class NowDateTransform: TransformType {
  typealias Object = Date
  typealias JSON = Int

  fileprivate let now: Date

  init(now: Date) {
    self.now = now
  }

  func transformFromJSON(_ value: AnyObject?) -> Object? {
    guard let value = value as? Int else {
      return nil
    }
    return now.addingTimeInterval(Double(value))
  }

  func transformToJSON(_ value: Object?) -> JSON? {
    return value.flatMap { Int($0.timeIntervalSince(now)) }
  }
}
