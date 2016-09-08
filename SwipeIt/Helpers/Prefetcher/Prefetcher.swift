//
//  Prefetcher.swift
//  Reddit
//
//  Created by Ivan Bruel on 07/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import Kingfisher

class Prefetcher {

  fileprivate var imagePrefetcher: ImagePrefetcher!
  fileprivate let completion: ((UIImage?) -> Void)?

  init(imageURL: URL, completion: ((UIImage?) -> Void)?) {
    self.completion = completion
    imagePrefetcher = ImagePrefetcher(urls: [imageURL]) {
      [weak self] (skippedResources, _, completedResources) in
      if let resource = completedResources.first ?? skippedResources.first {
        KingfisherManager().cache.retrieveImageForKey(resource.cacheKey, options: nil) {
          (image, _) in
          self?.completion?(image)
        }
      }
    }
  }

  func start() {
    imagePrefetcher?.start()
  }

  func stop() {
    imagePrefetcher?.stop()
  }
}
