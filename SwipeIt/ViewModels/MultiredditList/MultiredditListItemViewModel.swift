//
//  MultiredditListItemViewModel.swift
//  Reddit
//
//  Created by Ivan Bruel on 06/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

class MultiredditListItemViewModel: ViewModel {

  // MARK: Private Properties
  fileprivate let user: User
  fileprivate let accessToken: AccessToken
  fileprivate let multireddit: Multireddit

  let name: String
  let subreddits: String

  var linkSwipeViewModel: LinkSwipeViewModel {
    return LinkSwipeViewModel(user: user, accessToken: accessToken, multireddit: multireddit)
  }

  init(user: User, accessToken: AccessToken, multireddit: Multireddit) {
    self.user = user
    self.accessToken = accessToken
    self.multireddit = multireddit

    name = multireddit.name
    subreddits = MultiredditListItemViewModel.subredditString(multireddit.subreddits)
  }

}

// MARK: Helpers
extension MultiredditListItemViewModel {

  fileprivate class func subredditString(_ subreddits: [String]) -> String {
    switch subreddits.count {
    case 0..<4:
      return subreddits.joined(separator: ", ")
    default:
      return "\(subreddits.count) subreddits"
    }
  }
}
