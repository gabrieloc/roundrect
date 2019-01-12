//
//  ButtonStyle.swift
//  roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit

extension UIButton {  
  enum Size: String, CaseIterable {
    case small, big
  }
  
  enum ActionType: String, CaseIterable {
    case primary, dismiss
  }
  
  enum Style: Equatable {
    
    case gradient(from: UIColor, to: UIColor, cornerRadius: CGFloat)
    case bordered(cornerRadius: CGFloat)
    case filled(cornerRadius: CGFloat)
    case titleOnly
    
    func roundedButtonBackground(for theme: Theme, dim: Bool = false) -> UIImage? {
      let alpha: CGFloat = dim ? 0.05 : theme == .extraLight ? 0.1 : 1
      
      switch self {
      case .gradient(let from, let to, let cornerRadius):
        return UIImage.gradientImage(
          colors: [from, to].map {
            $0.withAlphaComponent(alpha)
          },
          cornerRadius: cornerRadius,
          insets: UIEdgeInsets(equalInsets: cornerRadius)
        )
      case .bordered(let cornerRadius),
           .filled(let cornerRadius):
        return UIImage.resizableImage(
          fill: fillColor(for: theme),
          stroke: (
            color: strokeColor(for: theme),
            width: strokeWidth
          ),
          cornerRadius: cornerRadius,
          insets: UIEdgeInsets(
            x: cornerRadius,
            y: cornerRadius
          ),
          alpha: alpha
          )?.withRenderingMode(.alwaysTemplate)
      default:
        return nil
      }
    }
    
    func fillColor(for theme: Theme) -> UIColor {
      switch self {
      case .filled:
        return theme == .dark ? .black : .white
      default:
        return .clear
      }
    }
    
    func strokeColor(for theme: Theme) -> UIColor {
      switch self {
      case .titleOnly,
           .gradient:
        return .clear
      default:
        return theme == .dark ? .black : .white
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
    
    func titleColor(for theme: Theme, state: UIControl.State) -> UIColor? {
      let color: UIColor? = {
        if case Style.gradient = self {
          return .white
        } else if state == .selected {
          return theme.inverse.foregroundColor
        } else if theme == .light && self == .titleOnly {
          return nil
        }
        return theme.foregroundColor
      }()
      let dim = state == .disabled
      return color?.withAlphaComponent(dim ? 0.4 : 1)
    }
    
    var defaultTheme: Theme {
      switch self {
      case .filled, .gradient:
        return .dark
      case .bordered:
        return .extraLight
      default:
        return .light
      }
    }
    
    static func ==(_ lhs: Style, _ rhs: Style) -> Bool {
      switch (lhs, rhs){
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
  
  convenience init(style: Style, size: Size = .big, theme: Theme? = nil, type: UIButton.ButtonType = .system) {
    self.init(type: type)
    
    setStyle(style, size: size, theme: theme)
  }
  
  func setStyle(_ style: Style, size: Size = .big, theme t: Theme? = nil) {
    
    let theme = t ?? style.defaultTheme
    
    backgroundColor = .clear
    
    let verticalInset: CGFloat = size == Size.small ? 10 : 16
    
    let normalImage = style.roundedButtonBackground(for: theme)
    setBackgroundImage(normalImage, for: .normal)
    
    let selectedStyle: Style
    if case Style.bordered(let radius) = style {
      selectedStyle = .filled(cornerRadius: radius)
    } else {
      selectedStyle = style
    }
    let selectedImage = selectedStyle.roundedButtonBackground(for: theme)
    setBackgroundImage(selectedImage, for: .selected)
    
    let highlightedImage = style.roundedButtonBackground(
      for: theme,
      dim: self.buttonType == .custom
    )
    setBackgroundImage(highlightedImage, for: .highlighted)
    
    let disabledStyle = Style.filled(cornerRadius: 10)
    let disabledImage = disabledStyle.roundedButtonBackground(
      for: theme,
      dim: true
    )
    setBackgroundImage(disabledImage, for: .disabled)
    
    setTitleColor(style.titleColor(for: theme, state: .normal), for: .normal)
    setTitleColor(style.titleColor(for: theme, state: .selected), for: .selected)
    setTitleColor(style.titleColor(for: theme, state: .disabled), for: .disabled)
    
    contentHorizontalAlignment = .center
    titleLabel?.adjustsFontSizeToFitWidth = true
    contentVerticalAlignment = .center
    
    contentEdgeInsets = UIEdgeInsets(x: 24, y: verticalInset)
  }
}
