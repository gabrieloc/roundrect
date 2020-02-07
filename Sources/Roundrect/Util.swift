//
//  ButtonUtil.swift
//  Roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
  public init(x: CGFloat, y: CGFloat) {
    self.init(top: y, left: x, bottom: y, right: x)
  }

  public init(equalInsets: CGFloat) {
    self.init(top: equalInsets, left: equalInsets, bottom: equalInsets, right: equalInsets)
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
