//
//  ButtonStyle.swift
//  roundrect
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
    
    func roundedButtonBackground(for theme: Theme, dim: Bool = false) -> UIImage? {
      let alpha: CGFloat = dim ? 0.05 : theme == .extraLight ? 0.1 : 1
      
      switch self {
      case .gradient(let from, let to, let rounding):
        return UIImage.gradientImage(
          colors: [from, to].map {
            $0.withAlphaComponent(alpha)
          },
          rounding: rounding,
          insets: rounding.insets
        )
      case .bordered(let rounding),
           .filled(let rounding):
        return UIImage.resizableImage(
          fill: fillColor(for: theme),
          stroke: (
            color: strokeColor(for: theme),
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
    
    public static func ==(_ lhs: Style, _ rhs: Style) -> Bool {
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
  
  public convenience init(style: Style, size: Size = .big, theme: Theme, type: UIButton.ButtonType = .system) {
    self.init(type: type)
    
    setStyle(style, size: size, theme: theme)
  }
  
  public func setStyle(_ style: Style, size: Size = .big, theme: Theme) {
    backgroundColor = .clear
    
    let verticalInset: CGFloat = size == Size.small ? 10 : 16
    
    let normalImage = style.roundedButtonBackground(for: theme)
    setBackgroundImage(normalImage, for: .normal)
    
    let selectedStyle: Style
    if case Style.bordered(let rounding) = style {
      selectedStyle = .filled(rounding: rounding)
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
    
    switch style {
      case .bordered(let rounding),
           .filled(let rounding),
           .gradient(_, _, let rounding):
        let disabledStyle = Style.filled(rounding: rounding)
        let disabledImage = disabledStyle.roundedButtonBackground(
          for: theme,
          dim: true
        )
        setBackgroundImage(disabledImage, for: .disabled)
        contentEdgeInsets = UIEdgeInsets(
          x: max(rounding.insets.left, rounding.insets.right),
          y: verticalInset
        )
    default:
      break
    }
    
    setTitleColor(style.titleColor(for: theme, state: .normal), for: .normal)
    setTitleColor(style.titleColor(for: theme, state: .selected), for: .selected)
    setTitleColor(style.titleColor(for: theme, state: .disabled), for: .disabled)
    
    contentHorizontalAlignment = .center
    titleLabel?.adjustsFontSizeToFitWidth = true
    contentVerticalAlignment = .center
  }
}
