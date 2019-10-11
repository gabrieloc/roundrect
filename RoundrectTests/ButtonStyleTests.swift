//
//  ButtonStyleTests.swift
//  RoundrectTests
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import FBSnapshotTestCase
@testable import Roundrect

class ButtonStyleTests: FBSnapshotTestCase {
  
  override func setUp() {
    super.setUp()
    recordMode = false
  }
  
  enum State: String, CaseIterable {
    case normal, highlighted, disabled
  }

  func testAllCombinations() {
    let styles = UIButton.Style.allValues(cornerRadius: 10)
    UIButton.Size.allCases.forEach { size in
      UIButton.Theme.allCases.forEach { theme in
        State.allCases.forEach { state in
          styles.forEach { style in
            verifyStyle(
              style,
              size: size,
              theme: theme,
              state: state
            )
          }
        }
      }
    }
  }
  
  func verifyStyle(_ style: UIButton.Style, size: UIButton.Size, theme: UIButton.Theme, state: State) {
    let button = UIButton(
      style: style,
      size: size,
      theme: theme,
      type: .system
    )
    button.isEnabled = state != .disabled
    button.isHighlighted = state == .highlighted
    button.frame = CGRect(
      origin: .zero,
      size: CGSize(
        width: 400,
        height: 40
      )
    )
    let identifier = [
      style.rawValue,
      size.rawValue,
      theme.rawValue,
      state.rawValue
      ]
      .joined(separator: "-")
    button.setTitle(identifier, for: .normal)
    FBSnapshotVerifyView(button, identifier: identifier)
  }
}

extension UIButton.Style: RawRepresentable {
  public typealias RawValue = String

  public init?(rawValue: String) {
    return nil
  }
  
  public var title: String {
    switch self {
    case .gradient:
      return "Gradient"
    case .bordered:
      return "Bordered"
    case .filled:
      return "Filled"
    case .titleOnly:
      return "Titled"
    }
  }
  
  public var rawValue: String {
    switch self {
    case .gradient(let from, let to, let cornerRadius):
      return "gradient \(cornerRadius) \(from)-\(to)"
    case .bordered(let cornerRadius):
      return "bordered \(cornerRadius)"
    case .filled(let cornerRadius):
      return "filled \(cornerRadius)"
    case .titleOnly:
      return "titled"
    }
  }
  
  static func allValues(cornerRadius: CGFloat) -> [UIButton.Style] {
    let rounding = Rounding.all(cornerRadius)
    return [
      .filled(rounding: rounding),
      .bordered(rounding: rounding),
      .gradient(from: .red, to: .blue, rounding: rounding),
      .titleOnly
    ]
  }
}
