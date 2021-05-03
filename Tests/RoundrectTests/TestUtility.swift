//
//  TestUtility.swift
//
//
//  Created by Gabriel O'Flaherty-Chan on 2021-05-03.
//

import SnapshotTesting
import UIKit

@available(iOS 12.0, *)
extension Snapshotting where Value == UIImage, Format == UIImage {
  static func image(style: UIUserInterfaceStyle) -> Self {
    Snapshotting<UIView, UIImage>.image.pullback {
      let view = UIImageView(image: $0)
      if #available(iOS 13.0, *) {
        view.overrideUserInterfaceStyle = style
      }
      return view
    }
  }
}

extension UIColor {
  static let adaptive1 = UIColor(
    named: "bluered",
    in: Bundle.module,
    compatibleWith: nil
  )!

  static let adaptive2 = UIColor(
    named: "cyanmagenta",
    in: Bundle.module,
    compatibleWith: nil
  )!
}
