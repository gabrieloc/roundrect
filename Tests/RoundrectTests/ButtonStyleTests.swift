//
//  ButtonStyleTests.swift
//  RoundrectTests
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

@testable import Roundrect
import SnapshotTesting
import XCTest

class ButtonStyleTests: XCTestCase {
  enum State: String, CaseIterable {
    case normal, highlighted, disabled
  }

  let styles = UIButton.Style.allValues(cornerRadius: 10)

  @available(iOS 13, *)
  func testInterfaceStyleCombinations() {
    UIButton.Size.allCases.forEach { size in
      State.allCases.forEach { state in
        styles.forEach { style in
          let button = self.button(style: style, size: size, state: state)
          button.0.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
          verifyStyle(button: button.0, identifier: button.1 + "-light")

          button.0.overrideUserInterfaceStyle = UIUserInterfaceStyle.dark
          verifyStyle(button: button.0, identifier: button.1 + "-dark")
        }
      }
    }
  }

  @available(iOS, obsoleted: 13)
  func testAllCombinations() {
    UIButton.Size.allCases.forEach { size in
      UIButton.Theme.allCases.forEach { theme in
        State.allCases.forEach { state in
          styles.forEach { style in
            let button = self.button(style: style, size: size, theme: theme, state: state)
            verifyStyle(button: button.0, identifier: button.1)
          }
        }
      }
    }
  }

  func verifyStyle(button: UIButton, identifier: String, file: StaticString = #file, line: UInt = #line) {
    button.setTitle(identifier, for: .normal)
    assertSnapshot(
      matching: button, as: .image(size: CGSize(width: 400, height: 40)),
      named: identifier,
      file: file,
      line: line
    )
  }

  @available(iOS, obsoleted: 13)
  func button(style: UIButton.Style, size: UIButton.Size, theme: UIButton.Theme, state: State) -> (UIButton, String) {
    let button = UIButton(
      style: style,
      size: size,
      theme: theme,
      type: .system
    )
    button.isEnabled = state != .disabled
    button.isHighlighted = state == .highlighted
    let identifier = [
      style.rawValue,
      size.rawValue,
      theme.rawValue,
      state.rawValue,
    ]
    .joined(separator: "-")
    return (button, identifier)
  }

  @available(iOS 13, *)
  func button(style: UIButton.Style, size: UIButton.Size, state: State) -> (UIButton, String) {
    let button = UIButton(
      style: style,
      size: size,
      type: .system
    )
    button.isEnabled = state != .disabled
    button.isHighlighted = state == .highlighted
    let identifier = [
      style.rawValue,
      size.rawValue,
      state.rawValue,
    ]
    .joined(separator: "-")
    return (button, identifier)
  }
}

extension UIButton.Style: RawRepresentable {
  public typealias RawValue = String

  public init?(rawValue _: String) {
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
    case let .gradient(from, to, cornerRadius, _):
      return "gradient \(cornerRadius) \(from)-\(to)"
    case let .bordered(rounding, _, _, alpha):
      return "bordered \(rounding) \(alpha)"
    case let .filled(rounding, _, alpha):
      return "filled \(rounding) \(alpha)"
    case .titleOnly:
      return "titled"
    }
  }

  static func allValues(cornerRadius: CGFloat) -> [UIButton.Style] {
    let rounding = Rounding.all(cornerRadius)
    return [
      .filled(rounding: rounding, color: nil, alpha: 1),
      .bordered(rounding: rounding, color: nil, alpha: 1),
      .gradient(from: .red, to: .blue, rounding: rounding, alpha: 1),
      .titleOnly(color: .red, alpha: 1),
    ]
  }
}
