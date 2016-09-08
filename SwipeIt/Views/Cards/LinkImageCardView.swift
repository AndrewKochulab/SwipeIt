//
//  LinkImageCardView.swift
//  Reddit
//
//  Created by Ivan Bruel on 19/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit
import Async
import Kingfisher

class LinkImageCardView: LinkCardView {

  fileprivate static let fadeAnimationDuration: TimeInterval = 0.15

  override var viewModel: LinkItemViewModel? {
    didSet {
      guard let imageViewModel = viewModel as? LinkItemImageViewModel else { return }
      let options: [KingfisherOptionsInfoItem] =
        [.Transition(.Fade(LinkImageCardView.fadeAnimationDuration))]
      imageView
        .kf_setImageWithURL(imageViewModel.imageURL, optionsInfo: options) {
          [weak self] (image, _, _, imageURL) in
          guard let image = image, let backgroundImageView = self?.backgroundImageView
            , imageURL == imageViewModel.imageURL else {
              self?.backgroundImageView.image = nil
              return
          }
          LinkImageCardView.blurImage(image, into: backgroundImageView)
      }
    }
  }

  // MARK: - Views
  fileprivate lazy var imageContentView: UIView = self.createImageContentView()
  fileprivate lazy var imageView: UIImageViewTopAligned = self.createImageView()
  fileprivate lazy var backgroundImageView: UIImageView = self.createBackgroundImageView()

  // MARK - Initializers
  override init() {
    super.init(frame: .zero)
    commonInit()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  fileprivate func commonInit() {
    contentView = imageContentView
    setupConstraints()
  }

  fileprivate func setupConstraints() {
    imageView.snp_makeConstraints { make in
      make.edges.equalTo(imageContentView)
    }

    backgroundImageView.snp_makeConstraints { make in
      make.edges.equalTo(imageContentView)
    }
  }

  override func didAppear() {
    super.didAppear()
    imageView.startAnimating()
  }

  override func didDisappear() {
    super.didDisappear()
    imageView.stopAnimating()
  }
}

extension LinkImageCardView {

  /**
   Blurs the provided image and sets it in the image view.
   In order to save memory this function also scales down the image before processing.
   In the end it will fade in the image into the image view.

   - parameter image:     The image to be blurred.
   - parameter imageView: The imageView in which to set the blurred image.
   */
  fileprivate static func blurImage(_ image: UIImage, into imageView: UIImageView) {
    Async.background {
      let scaledImage = resizeImage(image, imageView: imageView)
      let blurredImage = scaledImage.applyExtraLightEffect()
      Async.main {
        UIView.transitionWithView(imageView, duration: fadeAnimationDuration,
          options: .TransitionCrossDissolve, animations: {
            imageView.image = blurredImage
          }, completion: nil)
      }
    }
  }

  fileprivate static func resizeImage(_ image: UIImage, imageView: UIImageView) -> UIImage {
    let screenWidth = UIScreen.main.bounds.width
    let size = imageView.bounds.size != .zero ? imageView.bounds.size :
      CGSize(width: screenWidth, height: screenWidth)
    return image.scaleToSizeWithAspectFill(size)
  }

  fileprivate func createImageContentView() -> UIView {
    let view = UIView()
    view.backgroundColor = .clear()
    //view.clipsToBounds = true
    view.addSubview(self.backgroundImageView)
    view.addSubview(self.imageView)
    return view
  }

  fileprivate func createImageView() -> UIImageViewTopAligned {
    let imageView = UIImageViewTopAligned(frame: .zero)
    imageView.contentMode = .scaleAspectFit
    return imageView
  }

  fileprivate func createBackgroundImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }
}
