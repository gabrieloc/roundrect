//
//  ImageGeneration.swift
//  Roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit

public enum Rounding: Equatable {
  case all(CGFloat)
  case some(corners: UIRectCorner, radii: CGSize)

  var corners: UIRectCorner {
    switch self {
    case .all:
      return .allCorners
    case .some(let corners, _):
      return corners
    }
  }

  var radii: CGSize {
    switch self {
    case .all(let value):
      return CGSize(width: value, height: value)
    case .some(_, let radii):
      return radii
    }
  }

  var insets: UIEdgeInsets {
    return UIEdgeInsets(
      x: radii.width,
      y: radii.height
    )
  }
}

extension UIImage {
  public convenience init(view: UIView) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: image!.cgImage!)
  }

  public static func imageWithLayer(_ layer: CALayer) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    layer.render(in: context)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
  }

  public convenience init?(fill: UIColor, stroke: (color: UIColor, width: CGFloat)? = nil, rounding: Rounding? = nil) {
    let path = UIBezierPath(
      fill: fill,
      stroke: stroke,
      rounding: rounding
    )
    let strokeWidth = stroke?.width ?? 0
    path.lineWidth = strokeWidth

    let contextRect = path.bounds.insetBy(
      dx: -strokeWidth * 0.5,
      dy: -strokeWidth * 0.5
    )

    UIGraphicsBeginImageContextWithOptions(
      contextRect.size,
      false,
      UIScreen.main.scale
    )

    fill.setFill()
    path.fill()

    if let strokeColor = stroke?.color, strokeWidth > 0 {
      path.lineWidth = strokeWidth
      strokeColor.setStroke()
      path.stroke()
    }
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    guard let cgImage = image?.cgImage else {
      return nil
    }

    self.init(
      cgImage: cgImage,
      scale: UIScreen.main.scale,
      orientation: .up
    )
  }

  public static func resizableImage(fill: UIColor, stroke: (color: UIColor, width: CGFloat)? = nil, rounding: Rounding? = nil, insets: UIEdgeInsets? = nil, alpha: CGFloat = 1) -> UIImage? {
    guard let image = UIImage(
      fill: fill,
      stroke: stroke,
      rounding: rounding
    ) else {
      return nil
    }
    return image.withAlpha(alpha).resizableImage(
      withCapInsets: insets ?? rounding?.insets ?? .zero,
      resizingMode: .stretch
    )
  }

  public func withAlpha(_ alpha: CGFloat) -> UIImage {
    defer {
      UIGraphicsEndImageContext()

    }
    UIGraphicsBeginImageContextWithOptions(
      size,
      false,
      scale
    )
    draw(
      at: CGPoint.zero,
      blendMode: .normal,
      alpha: alpha
    )
    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    return newImage
      .resizableImage(withCapInsets: capInsets, resizingMode: resizingMode)
      .withRenderingMode(renderingMode)
  }

  public static func gradientImage(colors: [UIColor], rounding: Rounding? = nil, insets: UIEdgeInsets, stops: (start: CGPoint, end: CGPoint) = (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0))) -> UIImage? {
    let rect = CGRect(
      origin: .zero,
      size: CGSize(
        width: insets.left + insets.right + 50,
        height: insets.top + insets.bottom + 50
      )
    )

    let gradient = CAGradientLayer()
    gradient.frame = rect
    gradient.startPoint = stops.start
    gradient.endPoint = stops.end
    gradient.colors = colors.map { $0.cgColor }

    if let rounding = rounding {
      let maskLayer = CAShapeLayer()
      maskLayer.path = UIBezierPath(
        roundedRect: rect,
        byRoundingCorners: rounding.corners,
        cornerRadii: rounding.radii
      ).cgPath
      maskLayer.frame = rect
      gradient.mask = maskLayer
    }

    return UIImage.imageWithLayer(gradient)?.resizableImage(
      withCapInsets: insets,
      resizingMode: .stretch
    )
  }
}

extension UIBezierPath {
  public convenience init(fill: UIColor, stroke: (color: UIColor, width: CGFloat)?, rounding: Rounding?) {

    let strokeWidth = stroke?.width ?? 0
    let size = CGSize(
      width: 1 + (rounding?.radii.width ?? 0) * 2,
      height: 1 + (rounding?.radii.height ?? 0) * 2
    )

    let rect = CGRect(
      origin: .zero,
      size: size
    )
      .insetBy(
        dx: -strokeWidth * 0.5,
        dy: -strokeWidth * 0.5
      )
      .offsetBy(
        dx: strokeWidth,
        dy: strokeWidth
      )
    if let rounding = rounding {
      self.init(
        roundedRect: rect,
        byRoundingCorners: rounding.corners,
        cornerRadii: rounding.radii
      )
    } else {
      self.init(
        rect: rect
      )
    }
  }
}
