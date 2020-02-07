//
//  ButtonStyle.swift
//  Roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit

extension UIButton {
  public enum Size: String, CaseIterable {
    case small, big
  }

  public enum ActionType: String, CaseIterable {
    case primary, dismiss
  }

  public enum Style: Equatable {
    static let highlightedAlpha: CGFloat = 0.2
    static let disabledAlpha: CGFloat = 0.5

    case gradient(from: UIColor, to: UIColor, rounding: Rounding, alpha: CGFloat)
    case bordered(rounding: Rounding, color: UIColor?, alpha: CGFloat)
    case filled(rounding: Rounding, color: UIColor?, alpha: CGFloat)
    case titleOnly(color: UIColor?, alpha: CGFloat)

    var rounding: Rounding? {
      switch self {
      case .bordered(let rounding, _, _),
         .filled(let rounding, _, _),
         .gradient(_, _, let rounding, _):
        return rounding
      case .titleOnly:
        return nil
      }
    }

    var disabledColor: UIColor {
      if #available(iOS 13, *) {
        return UIColor.tertiaryLabel
      }
      return UIColor.gray
    }

    var disabled: Style {
      switch self {
      case .filled(let rounding, let c, _),
         .bordered(let rounding, let c, _):
        if let color = c {
          return .filled(rounding: rounding, color: color.grayscale, alpha: 1)
        } else {
          return .filled(rounding: rounding, color: disabledColor, alpha: 1)
        }
      case .gradient(let from, let to, let rounding, _):
        return .gradient(from: from.grayscale, to: to.grayscale, rounding: rounding, alpha: Self.disabledAlpha)
      case .titleOnly(let c, _):
        if let color = c {
          return .titleOnly(color: color.grayscale, alpha: 1)
        } else {
          return .titleOnly(color: nil, alpha: Self.disabledAlpha)
        }
      }
    }

    var highlighted: Style {
      switch self {
      case .filled(let rounding, let c, _):
        return .filled(rounding: rounding, color: c, alpha: Self.highlightedAlpha)
      case .bordered(let rounding, let c, _):
        return .bordered(rounding: rounding, color: c, alpha: Self.highlightedAlpha)
      case .gradient(let from, let to, let rounding, _):
        return .gradient(
          from: from.withAlphaComponent(Self.highlightedAlpha),
          to: to.withAlphaComponent(Self.highlightedAlpha),
          rounding: rounding,
          alpha: Self.highlightedAlpha
        )
      case .titleOnly(let c, _):
        if let color = c {
          return .titleOnly(color: color, alpha: 1)
        } else {
          return .titleOnly(color: nil, alpha: Self.highlightedAlpha)
        }
      }
    }

    var backgroundImage: UIImage? {
      switch self {
      case .gradient(let from, let to, let rounding, let alpha):
        return UIImage.gradientImage(
          colors: [from.withAlphaComponent(alpha), to.withAlphaComponent(alpha)],
          rounding: rounding,
          insets: rounding.insets
        )
      case .bordered(let rounding, let c, let alpha):
        return UIImage.resizableImage(
          fill: .clear,
          stroke: (
            color: c ?? .black,
            width: strokeWidth
          ),
          rounding: rounding,
          insets: rounding.insets,
          alpha: alpha
        )?.withRenderingMode(c == nil ? .alwaysTemplate : .alwaysOriginal)
      case .filled(let rounding, let c, let alpha):
        return UIImage.resizableImage(
          fill: c ?? .black,
          stroke: nil,
          rounding: rounding,
          insets: rounding.insets,
          alpha: alpha
        )?.withRenderingMode(c == nil ? .alwaysTemplate : .alwaysOriginal)
      case .titleOnly:
        return nil
      }
    }

    var strokeWidth: CGFloat {
      switch self {
      case .titleOnly,
         .gradient:
        return 0
      default:
        return 1
      }
    }

    @available(iOS, obsoleted: 13)
    func titleColor(state: UIControl.State, theme: Theme) -> UIColor? {
      let color: UIColor? = {
        guard state != .disabled else {
          return theme.foregroundColor
        }

        switch self {
        case .titleOnly:
          return theme == .dark ? .white : nil
        case .gradient, .filled:
          return theme == .extraLight ? .black : .white
        case .bordered:
          return nil
        }
      }()
      let dim = state == .disabled
      return color?.withAlphaComponent(dim ? 0.4 : 1)
    }

    @available(iOS 13, *)
    func titleColor(state: UIControl.State) -> UIColor? {
      if state == .disabled {
        return UIColor.tertiaryLabel
      }
      switch self {
      case .titleOnly, .bordered:
        return nil
      case .gradient, .filled:
        return .white
      }
    }

    public static func == (_ lhs: Style, _ rhs: Style) -> Bool {
      switch (lhs, rhs) {
      case (.gradient(let lhsColors), .gradient(let rhsColors)):
        return lhsColors == rhsColors
      case (.bordered, .bordered),
         (.filled, .filled),
         (.titleOnly, .titleOnly):
        return true
      default:
        return false
      }
    }
  }

  @available(iOS 13.0, *)
  public convenience init(style: Style, size: Size = .big, type: UIButton.ButtonType = .system) {
    self.init(type: type)
    setStyle(style, size: size)
  }

  @available(iOS, obsoleted: 13)
  public convenience init(style: Style, size: Size = .big, theme: Theme, type: UIButton.ButtonType = .system) {
    self.init(type: type)

    setStyle(style, size: size, theme: theme)
  }

  var configurableStates: [UIControl.State] {
    return [.normal, .selected, .highlighted, .disabled]
  }

  @available(iOS, obsoleted: 13)
  public func setStyle(_ style: Style, size: Size = .big, theme: Theme) {
    configureCommonAttributes(style, size: size)
    if theme == .extraLight {
      setBackgroundImage(style.backgroundImage?.withAlpha(0.4), for: .normal)
    }
    configurableStates.forEach {
      setTitleColor(style.titleColor(state: $0, theme: theme), for: $0)
    }
  }

  @available(iOS 13, *)
  public func setStyle(_ style: Style, size: Size = .big) {
    configureCommonAttributes(style, size: size)
    configurableStates.forEach {
      setTitleColor(style.titleColor(state: $0), for: $0)
    }
  }

  private func configureCommonAttributes(_ style: Style, size: Size) {
    backgroundColor = .clear

    setBackgroundImage(style.backgroundImage, for: .normal)
    setBackgroundImage(style.highlighted.backgroundImage, for: .selected)
    setBackgroundImage(style.highlighted.backgroundImage, for: .highlighted)
    setBackgroundImage(style.disabled.backgroundImage?.withRenderingMode(.alwaysOriginal), for: .disabled)

    if let rounding = style.rounding {
      contentEdgeInsets = UIEdgeInsets(
        x: rounding.radii.height,
        y: size == .small ? 10 : 16
      )
    }
    contentHorizontalAlignment = .center
    titleLabel?.adjustsFontSizeToFitWidth = true
    contentVerticalAlignment = .center
  }
}
