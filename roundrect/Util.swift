//
//  ButtonUtil.swift
//  roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit

extension UIButton {
  public var isLoading: Bool {
    get {
      return viewWithTag("spinner".hashValue) != nil
    }
    set {
      if newValue && !isLoading {
        isEnabled = false
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.tag = "spinner".hashValue
        addSubview(spinner)
        spinner.addConstraints(
          [
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
          ]
        )
      } else if !newValue && isLoading, let spinner = viewWithTag("spinner".hashValue) {
        isEnabled = true
        spinner.removeFromSuperview()
      }
    }
  }
  
  func centerImage(spacing: CGFloat) {
    let inset = spacing * 0.5
    imageEdgeInsets = UIEdgeInsets(top: 0, left: -inset, bottom: 0, right: inset)
    titleEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: -inset)
    contentEdgeInsets = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
  }
}

extension UIEdgeInsets {
  
  public init(x: CGFloat, y: CGFloat) {
    self.init(top: y, left: x, bottom: y, right: x)
  }
  
  public init(equalInsets: CGFloat) {
    self.init(top: equalInsets, left: equalInsets, bottom: equalInsets, right: equalInsets)
  }
  
  public static var one: UIEdgeInsets {
    return UIEdgeInsets(x: 1, y: 1)
  }
  
  public static func *(_ lhs: UIEdgeInsets, _ rhs: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets(
      top: lhs.top * rhs,
      left: lhs.left * rhs,
      bottom: lhs.bottom * rhs,
      right: lhs.right * rhs
    )
  }
}

extension CGSize {
  public static func +(_ lhs: CGSize, _ rhs: CGSize) -> CGSize {
    return CGSize(
      width: lhs.width + rhs.width,
      height: lhs.height + rhs.height
    )
  }
}
