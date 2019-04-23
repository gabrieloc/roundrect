//
//  ButtonUtil.swift
//  roundrect
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

extension CGSize {
  static var one: CGSize {
    return CGSize(width: 1, height: 1)
  }
  
  static func +(_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
    return CGSize(
      width: lhs.width + rhs,
      height: lhs.height + rhs
    )
  }
}

extension UIBezierPath {
  convenience init(roundedRect rect: CGRect, topLeftRadius: CGFloat, topRightRadius: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat) {
    self.init()
    
    let tl = CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius)
    let tr = CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius)
    let bl = CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY - bottomLeftRadius)
    let br = CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY - bottomRightRadius)
    let topMidpoint = CGPoint(x: rect.midX, y: rect.minY)
    
    makeClockwiseShape: do {
      move(to: topMidpoint)
      
      addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
      addArc(withCenter: tr, radius: topRightRadius, startAngle: -CGFloat.pi/2, endAngle: 0, clockwise: true)
      
      addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
      addArc(withCenter: br, radius: bottomRightRadius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
      
      
      addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
      addArc(withCenter: bl, radius: bottomLeftRadius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
      
      
      addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
      addArc(withCenter: tl, radius: topLeftRadius, startAngle: CGFloat.pi, endAngle: -CGFloat.pi/2, clockwise: true)
      
      close()
    }
  }
}
