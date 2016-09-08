//
//  ListingType+Name.swift
//  Reddit
//
//  Created by Ivan Bruel on 05/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

extension ListingType {

  var name: String {
    switch self {
    case .hot:
      return tr(.listingTypeHot)
    case .new:
      return tr(.listingTypeNew)
    case .rising:
      return tr(.listingTypeRising)
    case .controversial:
      return tr(.listingTypeControversial)
    case .top:
      return tr(.listingTypeTop)
    case .gilded:
      return tr(.listingTypeGilded)
    }
  }

  static var names: [String] {
    return [tr(.listingTypeHot), tr(.listingTypeNew), tr(.listingTypeRising),
            tr(.listingTypeControversial), tr(.listingTypeTop)]
    //tr(.ListingTypeGilded)] Removed until comments are added
  }

}

extension ListingTypeRange {

  static var names: [String] {
    return [tr(.listingTypeRangeHour), tr(.listingTypeRangeDay), tr(.listingTypeRangeWeek),
            tr(.listingTypeRangeMonth), tr(.listingTypeRangeYear), tr(.listingTypeRangeAllTime)]
  }
}
