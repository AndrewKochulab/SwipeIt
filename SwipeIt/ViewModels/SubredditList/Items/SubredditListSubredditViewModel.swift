//
//  SubredditListSubredditViewModel.swift
//  Reddit
//
//  Created by Ivan Bruel on 02/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

// MARK: Properties and Initializer
class SubredditListSubredditViewModel: SubredditListItemViewModel {

  // MARK: Private Properties
  fileprivate let user: User
  fileprivate let accessToken: AccessToken
  fileprivate let subreddit: Subreddit

  // MARK: Public Properties
  var name: String {
    return subreddit.displayName
  }

  var linkSwipeViewModel: LinkSwipeViewModel {
    return LinkSwipeViewModel(user: user, accessToken: accessToken, subreddit: subreddit)
  }

  // MARK: Initializer
  init(user: User, accessToken: AccessToken, subreddit: Subreddit) {
    self.user = user
    self.accessToken = accessToken
    self.subreddit = subreddit
  }
}
