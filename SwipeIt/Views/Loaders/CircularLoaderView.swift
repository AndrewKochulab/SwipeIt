//
//  CircularLoaderView.swift
//  Reddit
//
//  Created by Ivan Bruel on 08/08/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import UIKit

@IBDesignable class CircularLoaderView: UIView {

  // MARK: - IBInspectable Properties
  @IBInspectable var progress: Float {
    get {
      return max(min(Float(progressLayer.progress ?? 0), 1), 0)
    }
    set {
      progressLayer.animated = false
      progressLayer.progress = CGFloat(progress)
    }
  }

  @IBInspectable var emptyLineColor: UIColor = UIColor.lightGray {
    didSet {
      layer.borderColor = emptyLineColor.cgColor
    }
  }

  @IBInspectable var progressLineColor: UIColor {
    get {
      return progressLayer.progressLineColor
    }
    set {
      progressLayer.progressLineColor = newValue
    }
  }

  @IBInspectable var emptyLineWidth: CGFloat = 1 {
    didSet {
      layer.borderWidth = emptyLineWidth
      progressLayer.emptyLineWidth = emptyLineWidth
    }
  }

  @IBInspectable var progressLineWidth: CGFloat {
    get {
      return progressLayer.progressLineWidth
    }
    set {
      progressLayer.progressLineWidth = newValue
    }
  }

  // MARK: - Initializers
  init() {
    super.init(frame: CGRect.zero)
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

  // MARK: - Private Functions
  fileprivate func commonInit() {
    isOpaque = false
    backgroundColor = .clear()
    progressLayer.contentsScale = UIScreen.main.scale
    progressLayer.progressLineWidth = 4
  }

  fileprivate var progressLayer: CircularLoaderLayer {
    return layer as! CircularLoaderLayer // swiftlint:disable:this force_cast
  }

  func setProgress(_ progress: Float, animated: Bool) {
    progressLayer.animated = animated
    progressLayer.removeAllAnimations()
    progressLayer.progress = CGFloat(progress)
    if progress == 0 {
      layer.setNeedsDisplay()
    }
  }
}

// MARK: - Layer Management
extension CircularLoaderView {

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2
  }

  override class var layerClass : AnyClass {
    return CircularLoaderLayer.self
  }
}

// MARK: - CircularLoaderLayer
private class CircularLoaderLayer: CALayer {

  @NSManaged var progress: CGFloat
  @NSManaged var animated: Bool
  @NSManaged var emptyLineWidth: CGFloat
  @NSManaged var progressLineWidth: CGFloat
  @NSManaged var progressLineColor: UIColor

  override func draw(in context: CGContext) {
    super.draw(in: context)

    UIGraphicsPushContext(context)

    let size = context.boundingBoxOfClipPath.integral.size
    drawProgressBar(size, context: context)

    UIGraphicsPopContext()
  }


  fileprivate func drawProgressBar(_ size: CGSize, context: CGContext) {
    guard progressLineWidth > 0  else { return }

    let arc = CGMutablePath()
    let initialValue = -CGFloat(M_PI_2)
    let angle = ((CGFloat(M_PI) * 2) * progress) + initialValue

    CGPathAddArc(arc, nil, size.width / 2, size.height / 2,
                 (min(size.width, size.height) / 2) - emptyLineWidth - (progressLineWidth / 2),
                 angle, initialValue, true)
    let strokedArc = CGPath(__byStroking: arc, transform: nil, lineWidth: progressLineWidth, lineCap: .butt, lineJoin: .miter, miterLimit: 10)
    context.addPath(strokedArc!)
    context.setStrokeColor(progressLineColor.cgColor)
    context.setFillColor(progressLineColor.cgColor)
    context.drawPath(using: .fillStroke)
  }

  override class func needsDisplay(forKey key: String) -> Bool {
    guard key == "progress" else {
      return super.needsDisplay(forKey: key)
    }
    return true
  }

  override func action(forKey event: String) -> CAAction? {
    guard let presentationLayer = presentation() , event == "progress" && animated else {
      return super.action(forKey: event)
    }
    let animation = CABasicAnimation(keyPath: "progress")
    animation.fromValue = presentationLayer.value(forKey: "progress")
    return animation
  }

}
