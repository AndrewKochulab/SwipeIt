//
//  ClosedInterval+Clamp.swift
//  Reddit
//
//  Created by Ivan Bruel on 22/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

extension ClosedRange {

  func clamp(_ value: Bound) -> Bound {
    return self.start > value ? self.start
      : self.end < value ? self.end
      : value
  }
}
