//
//  String+Regex.swift
//  Reddit
//
//  Created by Ivan Bruel on 08/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

extension String {

  func matchesWithRegex(_ pattern: String) -> Bool {
    return range(of: pattern, options: .regularExpression) != nil
  }

  func regexMatches(_ pattern: String) -> [NSTextCheckingResult] {
    let regex: NSRegularExpression
    do {
      regex = try NSRegularExpression(pattern: pattern, options: [])
    } catch {
      return []
    }

    return regex.matches(in: self, options: [],
                                        range: NSRange(location: 0, length: self.utf16.count))
  }
}
