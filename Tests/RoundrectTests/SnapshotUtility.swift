//
//  SnapshotUtility.swift
//  RoundrectTests
//
//  Created by Gabriel O'Flaherty-Chan on 2021-11-03.
//

import SnapshotTesting
import UIKit

extension Snapshotting where Value == UIView, Format == UIImage {
  static var image: Self {
    .image(
      precision: .fuzzyPrecision
    )
  }

  static func image(size: CGSize) -> Self {
    .image(
      precision: .fuzzyPrecision,
      size: size
    )
  }
}

extension Float {
  static var fuzzyPrecision: Self { 0.98 }
}
