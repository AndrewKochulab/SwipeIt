//
//  CircleButton.swift
//  Reddit
//
//  Created by Ivan Bruel on 18/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setImage(image(for: .normal)?.tint(.white()), for: .highlighted)
    setImage(image(for: .normal)?.tint(UIColor(named: .gray)), for: .disabled)

  }

  override func setImage(_ image: UIImage?, for state: UIControlState) {
    if state == .normal {
      setImage(image?.tint(.white()), for: .highlighted)
      setImage(image?.tint(UIColor(named: .gray)), for: .disabled)
    }
    super.setImage(image, for: state)
  }

  // MARK: - Lifecycle
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = min(bounds.size.height, bounds.size.width) / 2
  }

  override var isHighlighted: Bool {
    didSet {
      UIView.animate(withDuration: 0.15, animations: {
        if self.isHighlighted {
          self.backgroundColor = self.tintColor
        } else {
          self.backgroundColor = .white()
        }
      }) 
    }
  }
}
