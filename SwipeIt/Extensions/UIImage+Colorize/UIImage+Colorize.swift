//
//  UIImage+Colorize.swift
//  Reddit
//
//  Created by Ivan Bruel on 19/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

extension UIImage {

  func tint(_ color: UIColor) -> UIImage? {
    var image = withRenderingMode(.alwaysTemplate)
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    color.set()
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
}
