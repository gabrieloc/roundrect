//
//  ImageGenerationTests.swift
//  Roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

@testable import Roundrect
import SnapshotTesting
import XCTest

@available(iOS 13.0, *)
class ImageGenerationTests: XCTestCase {
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
      fill: .blue,
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testStrokedImage() {
    let image = UIImage(
      fill: .clear,
      stroke: (
        color: .blue,
        width: 1
      ),
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testStrokedImageNoLineWidth() {
    let image = UIImage(
      fill: .red,
      stroke: (
        color: .blue,
        width: 0
      ),
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testFilledAndStrokedImage() {
    let image = UIImage(
      fill: .red,
      stroke: (
        color: .blue,
        width: 10
      ),
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testRoundedImage() {
    let image = UIImage(
      fill: .blue,
      rounding: .all(10),
      traitCollection: .lightInterfaceStyle
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
      rounding: .all(10),
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testRoundedThickStrokedImage() {
    let image = UIImage(
      fill: .blue,
      stroke: (
        color: .red,
        width: 4
      ),
      rounding: .all(10),
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testConditionallyRoundedStrokedImage() {
    let image = UIImage(
      fill: .blue,
      stroke: (
        color: .red,
        width: 1
      ),
      rounding: .some(
        corners: [.bottomLeft, .topRight, .bottomRight],
        radii: 10
      ),
      traitCollection: .lightInterfaceStyle
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
      ),
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testRoundedGradientImage() {
    let image = UIImage.gradientImage(
      colors: [.blue, .red],
      rounding: .all(10),
      insets: .zero,
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testConditionallyRoundedGradientImage() {
    let image = UIImage.gradientImage(
      colors: [.blue, .red],
      rounding: .some(
        corners: [.bottomLeft, .topRight, .bottomRight],
        radii: 10
      ),
      insets: .zero,
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testSingleConditionalStrokeOnFlatEdge() {
    let image = UIImage(
      fill: .blue,
      stroke: (
        color: .red,
        width: 2
      ),
      strokeEdges: [.top, .left, .right],
      rounding: .some(
        corners: [.topLeft, .topRight],
        radii: 10
      ),
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testMultipleConditionalStrokesNoRounding() {
    let image = UIImage(
      fill: .blue,
      stroke: (
        color: .red,
        width: 2
      ),
      strokeEdges: [.left, .right],
      rounding: .none,
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testMultipleConditionalStrokesOnFlatEdge() {
    let image = UIImage(
      fill: .blue,
      stroke: (
        color: .red,
        width: 4
      ),
      strokeEdges: [.left, .right, .bottom],
      rounding: .some(corners: [.bottomLeft], radii: 10),
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func testConditionalStrokesOnRoundEdge() {
    let image = UIImage(
      fill: .blue,
      stroke: (
        color: .red,
        width: 4
      ),
      strokeEdges: [.top, .left, .right],
      rounding: .all(10),
      traitCollection: .lightInterfaceStyle
    )!
    verifyImage(image)
  }

  func verifyImage(_ image: UIImage, testName: String = #function, file: StaticString = #file, line: UInt = #line) {
    assertSnapshot(
      matching: UIImageView(image: image),
      as: .image(size: image.size),
      file: file,
      testName: testName,
      line: line
    )
  }
}
