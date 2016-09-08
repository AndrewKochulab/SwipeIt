//
//  ImgurImageProvider.swift
//  Reddit
//
//  Created by Ivan Bruel on 09/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation

class ImgurImageProvider: ImageProvider {

  fileprivate static let regex = "^https?://.*imgur.com/(?!a/)(?!gallery/)(\\w)+"
  fileprivate static let extensionRegex = "(.jpe?g|.png|.gif)$"


  static func imageURLFromLink(_ link: Link) -> URL? {
    guard let URLString = link.url.absoluteString else { return nil }

    // Isn't Imgur url
    guard URLString.matchesWithRegex(regex) else { return nil }

    // Is already an image url
    if URLString.matchesWithRegex(extensionRegex) {
      return link.url
    }

    // gifv to gif transformation
    if link.url.pathExtension == "gifv" {
      return link.url.deletingPathExtension?.appendingPathExtension("gif")
    }

    // Media is already a gif
    if let thumbnailURL = link.media?.thumbnailURL,
      thumbnailURL.pathExtension == "gif" {
      return thumbnailURL
    }

    // Media to gif transformation (ends with CODEh.jpg should be converted to CODE.gif)
    if let thumbnailURL = link.media?.thumbnailURL,
      let thumbnailURLString = thumbnailURL.absoluteString,
      thumbnailURLString.hasSuffix("h.jpg") {
      if let gifLink = thumbnailURLString.replacingOccurrences(of: "h.jpg", with: ".gif") {
        return URL(string: gifLink)
      }
    }

    // No extension (e.g. http://imgur.com/CODE) convert to http://i.imgur.com/CODE.jpg
    if link.url.pathExtension == "" {
      if let imageLink = URLString?.replacingOccurrences(of: "imgur.com", with: "i.imgur.com") {
        return URL(string: imageLink)?.appendingPathExtension("jpg")
      }
    }

    return nil
  }
}
