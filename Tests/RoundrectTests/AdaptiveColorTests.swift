//
//  AdaptiveColorTests.swift
//
//
//  Created by Gabriel O'Flaherty-Chan on 2021-05-03.
//

import Roundrect
import SnapshotTesting
import UIKit
import XCTest

@available(iOS 13.0, *)
class AdaptiveColorTests: XCTestCase {
  func testSingleFillLight() throws {
    assertSnapshot(
      matching: try XCTUnwrap(
        UIImage(
          fill: .adaptive1,
          stroke: (.adaptive2, 1),
          rounding: .all(10),
          traitCollection: UITraitCollection.current.withUserInterfaceStyle(.light)
        )
      ),
      as: .image(style: .light)
    )
  }

  func testSingleFillLightDark() throws {
    assertSnapshot(
      matching: try XCTUnwrap(
        UIImage(
          fill: .adaptive1,
          stroke: (.adaptive2, 1),
          rounding: .all(10),
          traitCollection: UITraitCollection.current.withUserInterfaceStyle(.dark)
        )
      ),
      as: .image(style: .dark)
    )
  }

  func testGradientFillLight() throws {
    assertSnapshot(
      matching: try XCTUnwrap(
        UIImage.gradientImage(
          colors: [.adaptive1, .adaptive2],
          rounding: .all(10),
          traitCollection: UITraitCollection.current.withUserInterfaceStyle(.light)
        )
      ),
      as: .image(style: .light)
    )
  }

  func testGradientFillDark() throws {
    assertSnapshot(
      matching: try XCTUnwrap(
        UIImage.gradientImage(
          colors: [.adaptive1, .adaptive2],
          rounding: .all(10),
          traitCollection: UITraitCollection.current.withUserInterfaceStyle(.dark)
        )
      ),
      as: .image(style: .dark)
    )
  }
}
