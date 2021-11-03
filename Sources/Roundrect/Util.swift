//
//  ButtonUtil.swift
//  Roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {
  init(x: CGFloat, y: CGFloat) {
    self.init(top: y, left: x, bottom: y, right: x)
  }

  init(equalInsets: CGFloat) {
    self.init(top: equalInsets, left: equalInsets, bottom: equalInsets, right: equalInsets)
  }

  init(value: CGFloat, edges: UIRectEdge) {
    self.init(
      top: edges.contains(.top) ? value : 0,
      left: edges.contains(.left) ? value : 0,
      bottom: edges.contains(.bottom) ? value : 0,
      right: edges.contains(.right) ? value : 0
    )
  }
}

extension UIColor {
  var grayscale: UIColor {
    var grayscale: CGFloat = 0
    var alpha: CGFloat = 0
    guard getWhite(&grayscale, alpha: &alpha) else {
      return self
    }
    return UIColor(white: grayscale, alpha: alpha)
  }
}

extension CGRect {
  var center: CGPoint {
    origin + CGPoint(x: size.width * 0.5, y: size.height * 0.5)
  }

  func point(at corner: UIRectCorner) -> CGPoint? {
    switch corner {
    case .topLeft:
      return CGPoint(x: minX, y: minY)
    case .bottomLeft:
      return CGPoint(x: minX, y: maxY)
    case .bottomRight:
      return CGPoint(x: maxX, y: maxY)
    case .topRight:
      return CGPoint(x: maxX, y: minY)
    default:
      return nil
    }
  }
}

extension UIRectEdge {
  var anticlockwiseCorners: (origin: UIRectCorner, destination: UIRectCorner)? {
    switch self {
    case .top:
      return (.topRight, .topLeft)
    case .left:
      return (.topLeft, .bottomLeft)
    case .bottom:
      return (.bottomLeft, .bottomRight)
    case .right:
      return (.bottomRight, .topRight)
    default:
      return nil
    }
  }
}

public struct OptionSetIterator<Element: OptionSet>: IteratorProtocol where Element.RawValue == Int {
  private let value: Element

  public init(element: Element) {
    value = element
  }

  private lazy var remainingBits = value.rawValue
  private var bitMask = 1

  public mutating func next() -> Element? {
    while remainingBits != 0 {
      defer { bitMask = bitMask &* 2 }
      if remainingBits & bitMask != 0 {
        remainingBits = remainingBits & ~bitMask
        return Element(rawValue: bitMask)
      }
    }
    return nil
  }
}

extension CGPoint {
  static func - (lhs: Self, rhs: Self) -> Self {
    Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  static func + (lhs: Self, rhs: Self) -> Self {
    Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  static func / (lhs: Self, rhs: CGFloat) -> Self {
    Self(x: lhs.x / rhs, y: lhs.y / rhs)
  }

  static func * (lhs: Self, rhs: CGFloat) -> Self {
    Self(x: lhs.x * rhs, y: lhs.y * rhs)
  }

  static func * (lhs: Self, rhs: Self) -> Self {
    Self(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
  }

  var magnitude: CGFloat {
    sqrt(x * x + y * y)
  }

  var normalized: Self {
    self / magnitude
  }

  var flipped: Self {
    Self(x: y, y: x)
  }
}

func lerp(_ lhs: CGPoint, _ rhs: CGPoint, _ t: CGFloat) -> CGPoint {
  lhs + (rhs - lhs) * t
}

func rad2deg<T>(_ number: T) -> T where T: FloatingPoint {
  number * 180 / .pi
}

extension CGFloat {
  static let tau = CGFloat.pi * 2
}

@available(iOS 13.0, *)
public extension UITraitCollection {
  static var lightInterfaceStyle: UITraitCollection {
    UITraitCollection.current.withUserInterfaceStyle(.light)
  }

  static var darkInterfaceStyle: UITraitCollection {
    UITraitCollection.current.withUserInterfaceStyle(.dark)
  }

  func withUserInterfaceStyle(_ style: UIUserInterfaceStyle) -> UITraitCollection {
    UITraitCollection(
      traitsFrom: [
        self,
        UITraitCollection(userInterfaceStyle: style),
      ]
    )
  }
}
