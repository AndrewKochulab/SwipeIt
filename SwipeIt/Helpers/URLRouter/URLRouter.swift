//
//  URLRouter.swift
//  Reddit
//
//  Created by Ivan Bruel on 04/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

class URLRouter {

  static let sharedInstance = URLRouter()

  func openURL(_ URL: Foundation.URL) -> Bool {
    return UIApplication.shared.openURL(URL)
  }

}
