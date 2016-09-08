//
//  LoadingState.swift
//  Reddit
//
//  Created by Ivan Bruel on 08/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

// MARK: - Enum Values
enum LoadingState: Equatable {

  /// Content is available and not loading any content
  case normal
  /// No Content is available
  case empty
  /// Got an error loading content
  case error
  /// Is loading content
  case loading
}

// MARK: - Equatable
func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
  switch (lhs, rhs) {
  case (.normal, .normal):
    return true
  case (.empty, .empty):
    return true
  case (.error, .error):
    return true
  case (.loading, .loading):
    return true
  default:
    return false
  }
}
