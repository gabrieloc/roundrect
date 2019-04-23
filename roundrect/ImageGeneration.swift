//
//  ImageGeneration.swift
//  roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit

public struct Corners: Equatable {
  let topLeft: CGFloat
  let topRight: CGFloat
  let bottomRight: CGFloat
  let bottomLeft: CGFloat
  
  var maxRadius: CGFloat {
    return max(topLeft, topRight, bottomRight, bottomLeft)
  }
  
  func path(in rect: CGRect) -> UIBezierPath {
    return UIBezierPath(
      roundedRect: rect,
      topLeftRadius: topLeft,
      topRightRadius: topRight,
      bottomLeftRadius: bottomLeft,
      bottomRightRadius: bottomRight
    )
  }
}

extension Corners {
  init(equalRadius radius: CGFloat) {
    self.topLeft = radius
    self.topRight = radius
    self.bottomRight = radius
    self.bottomLeft = radius
  }
}

public enum Rounding: Equatable {
  case all(radius: CGFloat)
  case some(corners: Corners)
  
  var insets: UIEdgeInsets {
    switch self {
    case .all(let radius):
      return UIEdgeInsets(
        equalInsets: radius
      )
    case .some(let corners):
      return UIEdgeInsets(
        equalInsets: corners.maxRadius
      )
    }
  }
  
  var corners: Corners {
    switch self {
    case .all(let radius):
      return Corners(equalRadius: radius)
    case .some(let corners):
      return corners
    }
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
    guard let context =  UIGraphicsGetCurrentContext() else {
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
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
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
    
    if let corners = rounding?.corners {
      let maskLayer = CAShapeLayer()
      maskLayer.path = corners.path(in: rect).cgPath
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
    let radiusInset = rounding?.corners.maxRadius ?? 0
    let size: CGSize = .one + radiusInset * 2
    
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
    if let corners = rounding?.corners {
      self.init(
        roundedRect: rect,
        topLeftRadius: corners.topLeft,
        topRightRadius: corners.topRight,
        bottomLeftRadius: corners.bottomLeft,
        bottomRightRadius: corners.bottomRight
      )
    } else {
      self.init(
        rect: rect
      )
    }
  }
}
