//
//  String+FirstLetter.swift
//  Reddit
//
//  Created by Ivan Bruel on 04/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

extension String {

  var firstLetter: String {
    if let firstCharacter: UnicodeScalar = unicodeScalars.first {
      if CharacterSet.decimalDigits.contains(UnicodeScalar(firstCharacter.value)!) {
        return "#"
      }
      return String(firstCharacter).uppercased()
    }
    return ""
  }

}
