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
  @available(iOS 13.0, *)
  func testGenerateSampleSheetLightDark() {
    let canvas = CGRect(
      origin: .zero,
      size: CGSize(
        width: 400,
        height: 400
      )
    )
    let sampleSheet = SampleSheet(frame: canvas)
    sampleSheet.overrideUserInterfaceStyle = .light
    assertSnapshot(matching: sampleSheet, as: .image, testName: #function + "-light")

    sampleSheet.overrideUserInterfaceStyle = .dark
    assertSnapshot(matching: sampleSheet, as: .image, testName: #function + "-dark")
  }

  @available(iOS 13.0, *)
  func testGenerateSampleSheet() {
    let canvas = CGRect(
      origin: .zero,
      size: CGSize(
        width: 1024,
        height: 512
      )
    )
    let themes = UIButton.Theme.allCases
    let sampleSheet = SampleSheet(frame: canvas, themes: themes)
    sampleSheet.overrideUserInterfaceStyle = .light
    assertSnapshot(matching: sampleSheet, as: .image)
  }
}
