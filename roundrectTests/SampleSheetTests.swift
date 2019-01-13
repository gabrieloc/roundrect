//
//  SampleSheetTests.swift
//  roundrectTests
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-12.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import FBSnapshotTestCase

class SampleSheetTests: FBSnapshotTestCase {  
  func testGenerateSampleSheet() {
    let canvas = CGRect(
      origin: .zero,
      size: CGSize(
        width: 512,
        height: 1024
      )
    )
    let sampleSheet = SampleSheet(frame: canvas)
    FBSnapshotVerifyView(sampleSheet)
  }
}

