//
//  ListingType.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/03/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

enum ListingType: Equatable {

  case hot
  case new
  case rising
  case controversial(range: ListingTypeRange)
  case top(range: ListingTypeRange)
  case gilded

  var path: String {
    switch self {
    case .hot:
      return "hot"
    case .new:
      return "new"
    case .rising:
      return "rising"
    case .controversial:
      return "controversial"
    case .top:
      return "top"
    case .gilded:
      return "gilded"
    }
  }



  var range: ListingTypeRange? {
    switch self {
    case .controversial(let range):
      return range
    case .top(let range):
      return range
    default:
      return nil
    }
  }



  static func typeAtIndex(_ index: Int, range: ListingTypeRange? = nil) -> ListingType? {
    switch index {
    case 0:
      return .hot
    case 1:
      return .new
    case 2:
      return .rising
    case 3:
      guard let range = range else { return nil }
      return .controversial(range: range)
    case 4:
      guard let range = range else { return nil }
      return .top(range: range)
    case 5:
      return .gilded
    default:
      return .hot
    }
  }

}

enum ListingTypeRange: String {
  case Hour = "hour"
  case Day = "day"
  case Week = "week"
  case Month = "month"
  case Year = "year"
  case AllTime = "all"

  static var ranges: [ListingTypeRange] {
    return [.Hour, .Day, .Week, .Month, .Year, .AllTime]
  }

  static func rangeAtIndex(_ index: Int) -> ListingTypeRange? {
    return ranges.get(index)
  }
}


func == (lhs: ListingType, rhs: ListingType) -> Bool {
  switch (lhs, rhs) {
  case (.hot, .hot):
    return true
  case (.new, .new):
    return true
  case (.rising, .rising):
    return true
  case (.controversial(let lhsRange), .controversial(let rhsRange)):
    return lhsRange == rhsRange
  case (.top(let lhsRange), .top(let rhsRange)):
    return lhsRange == rhsRange
  case (.gilded, .gilded):
    return true
  default:
    return false
  }
}
