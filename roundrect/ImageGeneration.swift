//
//  ImageGeneration.swift
//  roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit

extension UIImage {
  convenience init(view: UIView) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: image!.cgImage!)
  }
  
  static func imageWithLayer(_ layer: CALayer) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
    guard let context =  UIGraphicsGetCurrentContext() else {
      return nil
    }
    layer.render(in: context)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
  }
  
  convenience init?(fill: UIColor, stroke: (color: UIColor, width: CGFloat)? = nil, cornerRadius: CGFloat = 0, insets: UIEdgeInsets? = nil) {
    let path = UIBezierPath(
      fill: fill,
      stroke: stroke,
      cornerRadius: cornerRadius,
      insets: insets
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
  
  static func resizableImage(fill: UIColor, stroke: (color: UIColor, width: CGFloat)? = nil, cornerRadius: CGFloat = 0.0, insets: UIEdgeInsets? = nil, alpha: CGFloat = 1) -> UIImage? {
    let insets = insets ?? UIEdgeInsets(x: cornerRadius, y: cornerRadius)
    guard let image = UIImage(
      fill: fill,
      stroke: stroke,
      cornerRadius: cornerRadius,
      insets: insets
      ) else {
        return nil
    }
    let capInsets = UIEdgeInsets(x: insets.left, y: insets.top)
    return image.withAlpha(alpha).resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
  }
  
  func withAlpha(_ alpha: CGFloat) -> UIImage {
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
  
  var aspectRatio: CGFloat {
    return size.width / size.height
  }
  
  static func gradientImage(colors: [UIColor], cornerRadius: CGFloat = 0, insets: UIEdgeInsets, stops: (start: CGPoint, end: CGPoint) = (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0))) -> UIImage? {
    let gradient = CAGradientLayer()
    gradient.frame = CGRect(
      origin: .zero,
      size: CGSize(
        width: insets.left + insets.right + 50,
        height: insets.top + insets.bottom + 50
      )
    )
    gradient.startPoint = stops.start
    gradient.endPoint = stops.end
    gradient.colors = colors.map { $0.cgColor }
    gradient.cornerRadius = cornerRadius
    return UIImage.imageWithLayer(gradient)?.resizableImage(withCapInsets: insets, resizingMode: .stretch)
  }
}

extension UIBezierPath {
  convenience init(fill: UIColor, stroke: (color: UIColor, width: CGFloat)?, cornerRadius: CGFloat, insets: UIEdgeInsets?) {
    let size = CGSize(
      width: 1 + cornerRadius * 2,
      height: 1 + cornerRadius * 2
    )
    
    let insets = insets ?? UIEdgeInsets(
      x: cornerRadius,
      y: cornerRadius
    )
    
    let strokeWidth = stroke?.width ?? 0
    
    let rect = CGRect(
      origin: .zero,
      size: size
      )
      .insetBy(
        dx: -insets.left - strokeWidth * 0.5,
        dy: -insets.top - strokeWidth * 0.5
      )
      .offsetBy(
        dx: insets.left + strokeWidth,
        dy: insets.top + strokeWidth
    )
    if cornerRadius > 0 {
      self.init(
        roundedRect: rect,
        cornerRadius: cornerRadius
      )
    } else {
      self.init(
        rect: rect
      )
    }
  }
}
