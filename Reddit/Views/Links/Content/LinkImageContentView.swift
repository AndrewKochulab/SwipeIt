//
//  LinkImageContentView.swift
//  Reddit
//
//  Created by Ivan Bruel on 06/06/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import SnapKit
import Async
import Kingfisher
import RxColor

// MARK: Properties and Initializer
class LinkImageContentView: UIView {

  // MARK: IBInspectable
  @IBInspectable var spacing: CGFloat = 8 {
    didSet {
      indicatorLabel.snp_updateConstraints { make in
        make.right.equalTo(self).inset(spacing)
        make.top.equalTo(self).offset(spacing)
      }
    }
  }

  @IBInspectable var overlayCircleRadius: CGFloat = 44 {
    didSet {
      overlayLabel.snp_updateConstraints { make in
        make.height.width.equalTo(overlayCircleRadius * 2)
      }
    }
  }

  @IBInspectable var overlayBorderWidth: CGFloat = 1 {
    didSet {
      overlayLabel.layer.borderWidth = overlayBorderWidth
    }
  }

  // MARK: Inner Views
  private lazy var imageView: AnimatedImageView = {
    let imageView = AnimatedImageView()
    imageView.contentMode = .ScaleAspectFit
    // Better performance while scrolling
    imageView.framePreloadCount = 1
    return imageView
  }()

  private lazy var indicatorLabel: UILabel = {
    let indicatorLabel = InsettedLabel()
    indicatorLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
    indicatorLabel.layer.cornerRadius = 4
    indicatorLabel.layer.masksToBounds = true
    indicatorLabel.textAlignment = .Center
    indicatorLabel.insets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
    Theming.sharedInstance.backgroundColor
      .bindTo(indicatorLabel.rx_backgroundColor)
      .addDisposableTo(self.rx_disposeBag)
    Theming.sharedInstance.secondaryTextColor
      .bindTo(indicatorLabel.rx_textColor)
      .addDisposableTo(self.rx_disposeBag)
    return indicatorLabel
  }()

  private lazy var overlayView: UIView = {
    let overlayView = UIView()
    let tapGestureRecognizer =
      UITapGestureRecognizer(target: self, action: #selector(LinkImageContentView.overlayTapped))
    overlayView.addGestureRecognizer(tapGestureRecognizer)
    Theming.sharedInstance.backgroundColor
      .bindTo(overlayView.rx_backgroundColor)
      .addDisposableTo(self.rx_disposeBag)
    overlayView.addSubview(self.overlayLabel)
    return overlayView
  }()

  private lazy var overlayLabel: UILabel = {
    let overlayLabel = UILabel()
    overlayLabel.textAlignment = .Center
    overlayLabel.font = UIFont.systemFontOfSize(UIFont.buttonFontSize())
    overlayLabel.adjustsFontSizeToFitWidth = true
    overlayLabel.minimumScaleFactor = 0.5
    overlayLabel.layer.borderWidth = self.overlayBorderWidth
    Theming.sharedInstance.secondaryTextColor
      .subscribeNext { color in
        overlayLabel.textColor = color
        overlayLabel.layer.borderColor = color.CGColor
      }.addDisposableTo(self.rx_disposeBag)
    return overlayLabel
  }()

  private var heightConstraint: Constraint? = nil

  // MARK: Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  // MARK: Setup
  private func setup() {
    clipsToBounds = true
    addSubview(imageView)
    addSubview(indicatorLabel)
    addSubview(overlayView)

    setupConstraints()
  }

  private func setupConstraints() {
    imageView.snp_makeConstraints { make in
      make.edges.equalTo(self)
    }

    indicatorLabel.snp_makeConstraints { make in
      make.right.equalTo(self).inset(spacing)
      make.top.equalTo(self).offset(spacing)
    }

    overlayView.snp_makeConstraints { make in
      make.edges.equalTo(self)
    }

    overlayLabel.snp_makeConstraints { make in
      make.height.width.equalTo(overlayCircleRadius * 2)
      make.center.equalTo(overlayView)
    }
  }

  override func layoutSubviews() {
    overlayLabel.layer.cornerRadius = overlayLabel.bounds.width / 2
  }

  // MARK: API
  var overlayText: String? {
    get {
      return overlayLabel.text
    }
    set {
      overlayLabel.text = newValue
      if newValue != nil {
        imageView.autoPlayAnimatedImage = false
        showOverlay()
      } else {
        imageView.autoPlayAnimatedImage = Globals.autoPlayGIF
        hideOverlay()
      }
    }
  }

  var indicatorText: String? {
    get {
      return indicatorLabel.text
    }
    set {
      indicatorLabel.text = newValue
      indicatorLabel.hidden = newValue == nil
    }
  }

  func setImageWithURL(imageURL: NSURL?, completion: ((UIImage?, NSURL?) -> Void)? = nil) {
    imageView.kf_setImageWithURL(imageURL, optionsInfo: [.Transition(.Fade(0.25))]) {
      (image, _, _, imageURL) in
      completion?(image, imageURL)
    }
  }

  func playGIF() {
    imageView.startAnimating()
  }

  func stopGIF() {
    imageView.stopAnimating()
  }

  func setImageSize(size: CGSize) {
    heightConstraint?.uninstall()
    imageView.snp_updateConstraints { make in
      heightConstraint = make.height.equalTo(imageView.snp_width)
        .dividedBy(size.ratio).priority(999).constraint
    }
  }

  // Hides overlay upon a tap on the overlay
  func overlayTapped() {
    hideOverlay(true) { _ in
      self.imageView.startAnimating()
    }
  }

  func showOverlay(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
    animateOverlay(true, animated: animated, completion: completion)
  }

  func hideOverlay(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
    animateOverlay(false, animated: animated, completion: completion)
  }

  private func animateOverlay(show: Bool, animated: Bool, completion: ((Bool) -> Void)?) {
    UIView.animateWithDuration(0.25, animations: {
      self.overlayView.alpha = show ? 1 : 0
      }, completion: completion)
  }
}

// MARK: Helpers
extension LinkImageContentView {

  class func heightForWidth(imageSize: CGSize, width: CGFloat) -> CGFloat {
    let ratio = imageSize.height / imageSize.width
    let imageHeight = width * ratio
    return imageHeight
  }
}
