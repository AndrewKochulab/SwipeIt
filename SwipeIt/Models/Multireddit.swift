//
//  Multireddit.swift
//  Reddit
//
//  Created by Ivan Bruel on 27/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

struct Multireddit: Mappable {

  // MARK: Multireddit
  var name: String!
  var displayName: String!
  var path: String!
  var url: URL!
  var descriptionHTML: String?
  var descriptionMarkdown: String?
  var copiedFrom: String?
  var subreddits: [String]!
  var iconURL: URL?
  var editable: Bool!
  var visibility: MultiredditVisibility!
  var created: Date!
  var keyColor: String?
  var iconName: String?

  lazy var username: String? = self.parseUsername()

  // MARK: JSON
  init?(_ map: Map) { }

  mutating func mapping(_ map: Map) {
    name <- map["data.name"]
    displayName <- map["data.display_name"]
    url <- (map["data.path"], PermalinkTransform())
    path <- (map["data.path"], PathTransform())
    descriptionHTML <- map["data.description_html"]
    descriptionMarkdown <- map["data.description_md"]
    copiedFrom <- map["data.copied_from"]
    editable <- map["data.can_edit"]
    subreddits <- (map["data.subreddits"], JSONKeyTransform("name"))
    visibility <- map["data.visibility"]
    created <- (map["data.created_utc"], EpochDateTransform())
    iconURL <- (map["data.icon_url"], EmptyURLTransform())
    keyColor <- (map["data.key_color"], EmptyStringTransform())
    iconName <- (map["data.icon_name"], EmptyStringTransform())
  }

}

// MARK: Helpers
extension Multireddit {

  fileprivate func parseUsername() -> String? {
    do {
      let regex = try NSRegularExpression(pattern: "\(Constants.redditURL)/user/(.*)/m/",
                                          options: [])
      let path = self.url.absoluteString
      if let firstMatch = regex
        .firstMatch(in: path, options: [],
                            range: NSRange(location: 0, length: path.characters.count)) {
        let nsRange = firstMatch.rangeAt(1)
        let initialIndex = path.characters.index(path.startIndex, offsetBy: nsRange.location)
        let endIndex = path.characters.index(path.startIndex, offsetBy: nsRange.location + nsRange.length)

        return path.substring(with: initialIndex..<endIndex)
      }
    } catch { }
    return nil
  }
}
