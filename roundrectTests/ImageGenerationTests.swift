//
//  ImageGenerationTests.swift
//  roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import FBSnapshotTestCase
@testable import roundrect

class ImageGenerationTests: FBSnapshotTestCase {
  
  override func setUp() {
    super.setUp()
    recordMode = false
  }

  func testViewRasterization() {
    let view = UILabel()
    view.text = "👹"
    view.isOpaque = false
    view.sizeToFit()
    let image = UIImage(view: view)
    verifyImage(image)
  }
  
  func testFilledImage() {
    let image = UIImage(
      fill: .blue
      )!
    verifyImage(image)
  }
  
  func testStrokedImage() {
    let image = UIImage(
      fill: .clear,
      stroke: (
        color: .blue,
        width: 1
      )
      )!
    verifyImage(image)
  }
  
  func testStrokedImageNoLineWidth() {
    let image = UIImage(
      fill: .red,
      stroke: (
        color: .blue,
        width: 0
      )
      )!
    verifyImage(image)
  }
  
  func testFilledAndStrokedImage() {
    let image = UIImage(
      fill: .red,
      stroke: (
        color: .blue,
        width: 10
      )
    )!
    verifyImage(image)
  }
  
  func testRoundedImage() {
    let image = UIImage(
      fill: .blue,
      cornerRadius: 10
    )!
    verifyImage(image)
  }
  
  func testRoundedStrokedImage() {
    let image = UIImage(
      fill: .blue,
      stroke: (
        color: .red,
        width: 1
      ),
      cornerRadius: 10
      )!
    verifyImage(image)
  }
  
  func testGradientImage() {
    let image = UIImage.gradientImage(
      colors: [.blue, .red],
      insets: .zero,
      stops: (
        start: CGPoint(x: 0, y: 0),
        end: CGPoint(x: 1, y: 1)
      )
      )!
    verifyImage(image)
  }
  
  func testRoundedGradientImage() {
    let image = UIImage.gradientImage(
      colors: [.blue, .red],
      cornerRadius: 10,
      insets: .zero
      )!
    verifyImage(image)
  }
  
  func verifyImage(_ image: UIImage) {
    let imageView = UIImageView(image: image)
    imageView.frame = CGRect(
      origin: .zero,
      size: image.size
    )
    FBSnapshotVerifyView(imageView)
  }
}
