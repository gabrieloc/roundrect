//
//  ButtonTheme.swift
//  Roundrect
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-11.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit

// dark theme is dark button with light text
// light theme is light button with dark text
public extension UIButton {
  @available(iOS, obsoleted: 13, message: "Rely on UIUserInterfaceStyle")
  enum Theme: String, CaseIterable {
    case extraLight, light, dark

    var foregroundColor: UIColor {
      switch self {
      case .light, .extraLight:
        return .black
      default:
        return .white
      }
    }

    var inverse: Self {
      switch self {
      case .dark:
        return .light
      default:
        return .dark
      }
    }
  }
}
