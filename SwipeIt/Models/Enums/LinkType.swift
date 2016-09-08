//
//  LinkType.swift
//  Reddit
//
//  Created by Ivan Bruel on 18/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

enum LinkType: Equatable {

  case video
  case image
  case gif
  case album
  case selfPost
  case linkPost
}

extension LinkType {

  static func typeFromLink(_ link: Link) -> LinkType {
    if link.selfPost == true && link.selfText != nil {
      return .selfPost
    } else if link.media?.type == "video" {
      return .video
    } else if link.media?.type == "rich" {
      return .album
    } else if link.imageURL != nil {
      return link.imageURL?.pathExtension == "gif" ? .gif : .image
    } else {
      return .linkPost
    }
  }
}

func == (lhs: LinkType, rhs: LinkType) -> Bool {
  switch (lhs, rhs) {
  case (.video, .video):
    return true
  case (.image, .image):
    return true
  case (.album, .album):
    return true
  case (.selfPost, .selfPost):
    return true
  case (.linkPost, .linkPost):
    return true
  case (.gif, .gif):
    return true
  default:
    return false
  }
}
