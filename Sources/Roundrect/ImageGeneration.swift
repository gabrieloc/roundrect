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
  case some(corners: UIRectCorner, radii: CGFloat)

  var corners: UIRectCorner {
    switch self {
    case .all:
      return .allCorners
    case let .some(corners, _):
      return corners
    }
  }

  var radii: CGFloat {
    switch self {
    case let .all(value):
      return value
    case let .some(_, radii):
      return radii
    }
  }

  var insets: UIEdgeInsets {
    UIEdgeInsets(
      x: radii,
      y: radii
    )
  }

  func radius(for corner: UIRectCorner) -> CGFloat? {
    guard corners.contains(corner) else {
      return nil
    }
    return radii
  }
}

public extension UIImage {
  convenience init(view: UIView) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: image!.cgImage!)
  }

  static func imageWithLayer(_ layer: CALayer) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    layer.render(in: context)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
  }

  convenience init?(
    fill: UIColor,
    stroke: (color: UIColor, width: CGFloat)? = nil,
    strokeEdges: UIRectEdge = .all,
    rounding: Rounding? = nil
  ) {
    let strokeWidth = stroke?.width ?? 0
    let rect = CGRect(
      origin: .zero,
      size: CGSize(
        width: 1 + (rounding?.radii ?? 0) * 2,
        height: 1 + (rounding?.radii ?? 0) * 2
      )
    ).inset(
      by: UIEdgeInsets(
        value: strokeWidth * 0.5,
        edges: strokeEdges
      )
    )

    let assetSize = rect.inset(
      by: UIEdgeInsets(
        value: strokeWidth * -0.5,
        edges: strokeEdges
      )
    ).size

    UIGraphicsBeginImageContextWithOptions(assetSize, false, UIScreen.main.scale)

    let fillPath = UIBezierPath.fillPath(
      in: rect,
      rounding: rounding
    )
    fill.setFill()
    fillPath.fill()

    if let strokeColor = stroke?.color, strokeWidth > 0 {
      let strokePath = UIBezierPath.strokePath(
        in: rect,
        strokeEdges: strokeEdges,
        rounding: rounding,
        strokeWidth: strokeWidth
      )
      strokePath.lineWidth = strokeWidth
      strokeColor.setStroke()
      strokePath.stroke()
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

  static func resizableImage(
    fill: UIColor,
    stroke: (color: UIColor, width: CGFloat)? = nil,
    strokeEdges: UIRectEdge = .all,
    rounding: Rounding? = nil,
    insets: UIEdgeInsets? = nil,
    alpha: CGFloat = 1
  ) -> UIImage? {
    guard let image = UIImage(
      fill: fill,
      stroke: stroke,
      strokeEdges: strokeEdges,
      rounding: rounding
    ) else {
      return nil
    }
    return image.withAlpha(alpha).resizableImage(
      withCapInsets: insets ?? rounding?.insets ?? .zero,
      resizingMode: .stretch
    )
  }

  func withAlpha(_ alpha: CGFloat) -> UIImage {
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

  static func gradientImage(colors: [UIColor], rounding: Rounding? = nil, insets: UIEdgeInsets, stops: (start: CGPoint, end: CGPoint) = (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0))) -> UIImage? {
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
        cornerRadii: CGSize(width: rounding.radii, height: rounding.radii)
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

public extension UIBezierPath {
  static func fillPath(
    in rect: CGRect,
    rounding: Rounding?
  ) -> Self {
    guard let rounding = rounding else {
      return .init(rect: rect)
    }
    return .init(
      roundedRect: rect,
      byRoundingCorners: rounding.corners,
      cornerRadii: CGSize(
        width: rounding.radii,
        height: rounding.radii
      )
    )
  }

  func addArcSegment(for edge: UIRectEdge, rounding: Rounding?, rect: CGRect, center: CGPoint) {
    guard
      let corners = edge.anticlockwiseCorners,
      let origin = rect.point(at: corners.origin),
      let destination = rect.point(at: corners.destination)
    else {
      return
    }
    let direction = (destination - origin).normalized
    func rad(_ p: CGPoint) -> CGFloat {
      let rad = atan2(p.x, p.y)
      var angle = (rad - .pi * 0.5) * -1
      if angle > .pi { // TODO: learn trigonometry
        angle = (.pi * 2 - angle) * -1
      }
      return angle
    }

    func arc(radius: CGFloat, from: CGPoint, to: CGPoint) {
      addArc(
        withCenter: center,
        radius: radius,
        startAngle: rad(from - center),
        endAngle: rad(to - center),
        clockwise: false
      )
    }

    if let originRadius = rounding?.radius(for: corners.origin) {
      let pivot = center + (origin - center).normalized * originRadius
      let insetOrigin = origin + direction * originRadius
      arc(
        radius: (insetOrigin - center).magnitude,
        from: pivot,
        to: insetOrigin
      )
      addLine(to: insetOrigin)
    } else {
      move(to: origin)
    }

    if let destinationRadius = rounding?.radius(for: corners.destination) {
      let insetDestination = destination - direction * destinationRadius
      addLine(to: insetDestination)
      let pivot = center + (destination - center).normalized * destinationRadius
      arc(
        radius: (insetDestination - center).magnitude,
        from: insetDestination,
        to: pivot
      )
    } else {
      addLine(to: destination)
    }
  }

  static func strokePath(
    in rect: CGRect,
    strokeEdges: UIRectEdge,
    rounding: Rounding?,
    strokeWidth: CGFloat
  ) -> UIBezierPath {
    let path = UIBezierPath()

    // recalculate the center to ensure segments align
    var center = rect.center
    center.y += strokeEdges.contains(.top) ? 0 : strokeWidth * 0.25
    center.y += strokeEdges.contains(.bottom) ? 0 : strokeWidth * -0.25
    center.x += strokeEdges.contains(.right) ? 0 : strokeWidth * 0.25
    center.x += strokeEdges.contains(.left) ? 0 : strokeWidth * -0.25

    if strokeEdges.contains(.top) {
      path.addArcSegment(for: .top, rounding: rounding, rect: rect, center: center)
    }
    if strokeEdges.contains(.left) {
      path.addArcSegment(for: .left, rounding: rounding, rect: rect, center: center)
    }
    if strokeEdges.contains(.bottom) {
      path.addArcSegment(for: .bottom, rounding: rounding, rect: rect, center: center)
    }
    if strokeEdges.contains(.right) {
      path.addArcSegment(for: .right, rounding: rounding, rect: rect, center: center)
    }
    return path
  }
}
