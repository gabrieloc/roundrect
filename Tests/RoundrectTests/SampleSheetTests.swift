//
//  SampleSheetTests.swift
//  RoundrectTests
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-12.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import SnapshotTesting
import XCTest

class SampleSheetTests: XCTestCase {
  @available(iOS 13, *)
  func testGenerateSampleSheetLightDark() {
    let canvas = CGRect(
      origin: .zero,
      size: CGSize(
        width: 512,
        height: 512
      )
    )

    record = true

    let sampleSheet = SampleSheet(frame: canvas)
    sampleSheet.overrideUserInterfaceStyle = .light
    assertSnapshot(matching: sampleSheet, as: .image, testName: #function + "-light")

    sampleSheet.overrideUserInterfaceStyle = .dark
    assertSnapshot(matching: sampleSheet, as: .image, testName: #function + "-dark")
  }

  @available(iOS, obsoleted: 13)
  func testGenerateSampleSheet() {
    let canvas = CGRect(
      origin: .zero,
      size: CGSize(
        width: 1024,
        height: 512
      )
    )
    let sampleSheet = SampleSheet(frame: canvas)
    assertSnapshot(matching: sampleSheet, as: .image)
  }
}

