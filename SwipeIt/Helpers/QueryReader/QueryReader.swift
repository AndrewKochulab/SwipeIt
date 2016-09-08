//
//  QueryReader.swift
//  Reddit
//
//  Created by Ivan Bruel on 26/04/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

class QueryReader {

  class func queryParametersFromString(_ URLString: String) -> [String: String] {
    guard let URLComponents = URLComponents(string: URLString) else {
      return [:]
    }
    return URLComponents.queryItems?.reduce([:]) { (dictionary, queryItem) -> [String: String] in
      var dictionary = dictionary
      if let value = queryItem.value {
        dictionary[queryItem.name] = value
      }
      return dictionary
    } ?? [:]
  }

}
