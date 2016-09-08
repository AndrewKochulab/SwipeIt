//
//  MarkdownSubreddit.swift
//  Reddit
//
//  Created by Ivan Bruel on 01/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import MarkdownKit

class MarkdownSubreddit: MarkdownLink {

  fileprivate static let regex = "(^|\\s|\\W)(/?r/(\\w+)/?)"

  override var regex: String {
    return MarkdownSubreddit.regex
  }

  override func match(_ match: NSTextCheckingResult,
                      attributedString: NSMutableAttributedString) {
    let subredditName = attributedString.attributedSubstring(from: match.rangeAt(3)).string
    let linkURLString = "http://reddit.com/r/\(subredditName)"
    formatText(attributedString, range: match.range, link: linkURLString)
    addAttributes(attributedString, range: match.range, link: linkURLString)
  }
}
