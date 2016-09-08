//
//  NSAttributedString+Join.swift
//  Reddit
//
//  Created by Ivan Bruel on 05/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: NSAttributedString {
  func joinWithSeparator(_ separator: NSAttributedString) -> NSAttributedString {
    var isFirst = true
    return self.reduce(NSMutableAttributedString()) {
      (r, e) in
      if isFirst {
        isFirst = false
      } else {
        r.append(separator)
      }
      r.append(e)
      return r
    }
  }

  func joinWithSeparator(_ separator: String) -> NSAttributedString {
    return joinWithSeparator(NSAttributedString(string: separator))
  }
}
