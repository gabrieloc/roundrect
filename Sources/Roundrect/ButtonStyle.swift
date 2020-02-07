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

    case gradient(from: UIColor, to: UIColor, rounding: Rounding)
    case bordered(rounding: Rounding)
    case filled(rounding: Rounding)
    case titleOnly

    var rounding: Rounding? {
      switch self {
      case .bordered(let rounding),
         .filled(let rounding),
         .gradient(_, _, let rounding):
        return rounding
      case .titleOnly:
        return nil
      }
    }

    @available(iOS, obsoleted: 13)
    func roundedButtonBackground(for theme: Theme, dim: Bool = false) -> UIImage? {
      let alpha: CGFloat = dim ? 0.05 : theme == .extraLight ? 0.1 : 1
      return roundedButtonBackground(dim: dim, alpha: alpha)
    }

    func roundedButtonBackground(dim: Bool = false, alpha: CGFloat = 1) -> UIImage? {
      switch self {
      case .gradient(let from, let to, let rounding):
        return UIImage.gradientImage(
          colors: [from, to],
          rounding: rounding,
          insets: rounding.insets
        )
      case .bordered(let rounding),
         .filled(let rounding):
        return UIImage.resizableImage(
          fill: maskFillColor,
          stroke: (
            color: maskStrokeColor,
            width: strokeWidth
          ),
          rounding: rounding,
          insets: rounding.insets,
          alpha: alpha
        )?.withRenderingMode(.alwaysTemplate)
      default:
        return nil
      }
    }

    var maskFillColor: UIColor {
      switch self {
      case .filled:
        return .black
      default:
        return .clear
      }
    }

    var maskStrokeColor: UIColor {
      switch self {
      case .titleOnly,
         .gradient:
        return .clear
      default:
        return .black
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
    func titleColor(for theme: Theme, state: UIControl.State) -> UIColor? {
      let color: UIColor? = {
        if theme == .extraLight || state == .disabled {
          return theme.foregroundColor
        }

        switch self {
        case .titleOnly:
          return theme == .light ? nil : .white
        case .gradient, .filled:
          return .white
        case .bordered:
          return theme.foregroundColor
        }
      }()
      let dim = state == .disabled
      return color?.withAlphaComponent(dim ? 0.4 : 1)
    }

    @available(iOS 13, *)
    func titleColor(state: UIControl.State) -> UIColor? {
      let color: UIColor? = {
        if state == .disabled {
          return UIColor.tertiaryLabel
        }
        switch self {
        case .titleOnly, .bordered:
          return nil
        case .gradient, .filled:
          return .label
        }
      }()
      let dim = state == .disabled
      return color?.withAlphaComponent(dim ? 0.4 : 1)
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

  @available(iOS, obsoleted: 13)
  public func setStyle(_ style: Style, size: Size = .big, theme: Theme) {
    setAttributes(
        .init(
          normalAttributes: .init(
            background: { $0.roundedButtonBackground(for: theme) },
            textColor: style.titleColor(for: theme, state: .normal)
          ),
          highlightedAttributes: .init(
            background: { $0.roundedButtonBackground(for: theme) },
            textColor: style.titleColor(for: theme, state: .highlighted)
          ),
          selectedAttributes: .init(
            background: { $0.roundedButtonBackground(for: theme) }
            ,
            textColor: style.titleColor(for: theme, state: .selected)
          ),
          disabledAttributes: .init(
            background: { $0.roundedButtonBackground(for: theme) },
            textColor: style.titleColor(for: theme, state: .disabled)
          ),
          normalStyle: style,
          size: size
        )
    )
  }

  @available(iOS 13, *)
  public func setStyle(_ style: Style, size: Size = .big) {
    setAttributes(
        .init(
          normalAttributes: .init(
            background: { $0.roundedButtonBackground() },
            textColor: style.titleColor(state: .normal)
          ),
          highlightedAttributes: .init(
            background: { $0.roundedButtonBackground() },
            textColor: style.titleColor(state: .highlighted)
          ),
          selectedAttributes: .init(
            background: { $0.roundedButtonBackground() },
            textColor: style.titleColor(state: .selected)
          ),
          disabledAttributes: .init(
            background: { $0.roundedButtonBackground() },
            textColor: style.titleColor(state: .disabled)
          ),
          normalStyle: style,
          size: size
        )
    )
  }

  struct StateAttributes {
    struct Attributes {
      let background: (UIButton.Style) -> UIImage?
      let textColor: UIColor?
    }

    let normalAttributes: Attributes
    let highlightedAttributes: Attributes
    let selectedAttributes: Attributes
    let disabledAttributes: Attributes
    let normalStyle: UIButton.Style
    let size: Size
  }

  func setAttributes(_ attributes: StateAttributes) {
    backgroundColor = .clear

    let selectedStyle: Style = {
      if case Style.bordered(let rounding) = attributes.normalStyle {
        return .filled(rounding: rounding)
      }
      return attributes.normalStyle
    }()


    let disabledStyle: Style = {
      if let rounding = attributes.normalStyle.rounding {
        return .filled(rounding: rounding)
      }
      return attributes.normalStyle
    }()

    setBackgroundImage(attributes.normalAttributes.background(attributes.normalStyle), for: .normal)
    setBackgroundImage(attributes.selectedAttributes.background(selectedStyle), for: .selected)
    setBackgroundImage(attributes.highlightedAttributes.background(attributes.normalStyle), for: .highlighted)
    setBackgroundImage(attributes.disabledAttributes.background(disabledStyle), for: .disabled)

    setTitleColor(attributes.normalAttributes.textColor, for: .normal)
    setTitleColor(attributes.selectedAttributes.textColor, for: .selected)
    setTitleColor(attributes.highlightedAttributes.textColor, for: .highlighted)
    setTitleColor(attributes.disabledAttributes.textColor, for: .disabled)

    if let rounding = attributes.normalStyle.rounding {
      contentEdgeInsets = UIEdgeInsets(
        x: rounding.radii.height,
        y: attributes.size == .small ? 10 : 16
      )
    }
    contentHorizontalAlignment = .center
    titleLabel?.adjustsFontSizeToFitWidth = true
    contentVerticalAlignment = .center
  }
}
