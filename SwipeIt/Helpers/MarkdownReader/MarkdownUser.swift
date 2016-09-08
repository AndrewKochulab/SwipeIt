//
//  MarkdownUser.swift
//  Reddit
//
//  Created by Ivan Bruel on 01/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import MarkdownKit

class MarkdownUser: MarkdownLink {

  fileprivate static let regex = "(^|\\s|\\W)(/?u/(\\w+)/?)"

  override var regex: String {
    return MarkdownUser.regex
  }

  override func match(_ match: NSTextCheckingResult,
                      attributedString: NSMutableAttributedString) {
    let username = attributedString.attributedSubstring(from: match.rangeAt(3)).string
    let linkURLString = "http://reddit.com/u/\(username)"
    formatText(attributedString, range: match.range, link: linkURLString)
    addAttributes(attributedString, range: match.range, link: linkURLString)
  }
}
