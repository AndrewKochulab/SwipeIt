//
//  MoreComments.swift
//  Reddit
//
//  Created by Ivan Bruel on 27/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import ObjectMapper

struct MoreComments: Thing, Mappable {

  // MARK: Thing
  var identifier: String!
  var name: String!
  var kind: String!

  // MARK: MoreComments
  var children: [String]!
  var count: Int!
  var parentId: String?

  // MARK: JSON
  init?(_ map: Map) { }

  mutating func mapping(_ map: Map) {
    mappingThing(map)
    mappingMoreComments(map)
  }

  fileprivate mutating func mappingMoreComments(_ map: Map) {
    children <- map["data.children"]
    count <- map["data.count"]
    parentId <- map["data.parent_id"]
  }

}
