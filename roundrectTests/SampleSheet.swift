//
//  SampleSheet.swift
//  roundrectTests
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-12.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit
@testable import roundrect

class SampleSheet: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let innerMargin: CGFloat = 8
    
    backgroundColor = .white
    
    let styles = UIButton.Style.allValues(cornerRadius: 10)
    let themes = UIButton.Theme.allCases
    let states = ButtonStyleTests.State.allCases
    
    let sheetInset = UIEdgeInsets(equalInsets: 32)
    
    let sheetFrame = frame.inset(by: sheetInset)
    
    let sectionMargin = (x: CGFloat(16), y: CGFloat(16))

    func sectionRect(for section: Int) -> CGRect {
      let (row, col) = (
        CGFloat(floor(CGFloat(section) / 2)),
        CGFloat(section % 2)
      )
      return CGRect(
        origin: CGPoint(
          x: sheetFrame.minX + (sheetFrame.width / 2 + sectionMargin.x) * col,
          y: sheetFrame.minY + (sheetFrame.height / 2 + sectionMargin.y) * row
        ),
        size: CGSize(
          width: (sheetFrame.width - sectionMargin.x) / 2,
          height: (sheetFrame.height - sectionMargin.y) / 2
        )
      )
    }
    
    styles.forEach { style in
      let section = styles.firstIndex(of: style)!
      let rect = sectionRect(for: section)
      
      let header = UILabel(
        frame: CGRect(
          origin: rect.origin,
          size: CGSize(
            width: rect.width,
            height: 64
          )
        )
      )
      header.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
      header.text = style.title
      addSubview(header)
      
      themes.forEach { theme in
        let columnWidth = rect.width / CGFloat(themes.count)
        let ti: CGFloat = CGFloat(themes.firstIndex(of: theme)!)
        let gutter: CGFloat = innerMargin * 0.5
        let themeFrame = CGRect(
          origin: CGPoint(
            x: rect.minX + columnWidth * ti,
            y: header.frame.maxY
          ),
          size: CGSize(
            width: columnWidth - (gutter + (CGFloat(themes.count) - 1) * ti),
            height: rect.height - header.frame.height
          )
        )
        let background = UIView(frame: themeFrame)
        background.backgroundColor = theme.inverse.foregroundColor
        addSubview(background)
        
        let sectionInset: CGFloat = 32
        let themeLabel = UILabel(
          frame: CGRect(
            origin: CGPoint(
              x: themeFrame.minX,
              y: themeFrame.minY + 4
            ),
            size: CGSize(
              width: themeFrame.width,
              height: 16
            )
          )
        )
        themeLabel.text = theme.rawValue.uppercased()
        themeLabel.font = UIFont.systemFont(ofSize: 12)
        themeLabel.textAlignment = .center
        addSubview(themeLabel)
        themeLabel.textColor = theme.foregroundColor.withAlphaComponent(0.5)
          
        states.forEach { state in
          let insetX = ti * gutter
          let stateHeight = (themeFrame.height - sectionInset) / CGFloat(states.count)
          let stateFrame = CGRect(
            origin: CGPoint(
              x: themeFrame.minX + insetX,
              y: sectionInset + themeFrame.minY + stateHeight * CGFloat(states.firstIndex(of: state)!)
            ),
            size: CGSize(
              width: themeFrame.width - insetX * 2,
              height: stateHeight
            )
          )
          let button = UIButton(
            style: style,
            size: .big,
            theme: theme,
            type: .system
          )
          let buttonHeight = stateFrame.height - innerMargin
          let buttonFrame = CGRect(
            origin: CGPoint(
              x: stateFrame.minX,
              y: stateFrame.midY - buttonHeight * 0.5
            ),
            size: CGSize(
              width: stateFrame.width,
              height: buttonHeight
            )
          )
          button.setTitle(state.rawValue.capitalized, for: .normal)
          button.isEnabled = state != .disabled
          button.isHighlighted = state == .highlighted
          button.frame = buttonFrame
          addSubview(button)
        }
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
