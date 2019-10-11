//
//  SampleSheetTests.swift
//  RoundrectTests
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-12.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import FBSnapshotTestCase

class SampleSheetTests: FBSnapshotTestCase {
  override func setUp() {
    super.setUp()
    recordMode = false
  }
  
  func testGenerateSampleSheet() {
    let canvas = CGRect(
      origin: .zero,
      size: CGSize(
        width: 1024,
        height: 512
      )
    )
    let sampleSheet = SampleSheet(frame: canvas)
    FBSnapshotVerifyView(sampleSheet)
  }
}

