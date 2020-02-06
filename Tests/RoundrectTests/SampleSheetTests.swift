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

