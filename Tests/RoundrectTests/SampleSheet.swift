//
//  SampleSheet.swift
//  RoundrectTests
//
//  Created by Gabriel O'Flaherty-Chan on 2019-01-12.
//  Copyright © 2019 gabrieloc. All rights reserved.
//

import UIKit
@testable import Roundrect

class SampleSheet: UIView {
  let innerMargin: CGFloat = 8
  let gutter: CGFloat = 4
  let styles = UIButton.Style.allValues(cornerRadius: 10)
  let states = ButtonStyleTests.State.allCases
  let sheetInset = UIEdgeInsets(equalInsets: 32)
  let sectionMargin = (x: CGFloat(16), y: CGFloat(16))
  let sectionInset: CGFloat = 32

  @available(iOS, obsoleted: 13)
  init(frame: CGRect, themes: [UIButton.Theme]) {
    super.init(frame: frame)

    styles.forEach { style in
      let section = styles.firstIndex(of: style)!
      let rect = sectionRect(in: frame.inset(by: sheetInset), section: section)

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

      header.textColor = .black
      backgroundColor = .white
      themes.forEach { theme in
        drawColumn(
          rect: rect,
          i: themes.firstIndex(of: theme)!,
          of: themes.count,
          name: theme.rawValue,
          textColor: theme.foregroundColor.withAlphaComponent(0.5),
          backgroundColor: theme.inverse.foregroundColor,
          style: style,
          headerFrame: header.frame,
          createButton: {
            UIButton(style: style, theme: theme)
          }
        )
      }
    }
  }

  @available (iOS 13.0, *)
  init(frame: CGRect, a: Bool = true) {
    super.init(frame: frame)

    styles.forEach { style in
      let section = styles.firstIndex(of: style)!
      let rect = sectionRect(in: frame.inset(by: sheetInset), section: section)

      let header = UILabel(
        frame: CGRect(
          origin: rect.origin,
          size: CGSize(
            width: rect.width,
            height: 40
          )
        )
      )
      header.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
      header.text = style.title
      addSubview(header)

      backgroundColor = .systemBackground
      drawColumn(
        rect: rect,
        i: 0,
        of: 1,
        name: nil,
        textColor: .label,
        backgroundColor: .systemBackground,
        style: style,
        headerFrame: header.frame) {
        UIButton(style: style)
      }
    }
  }

  func sectionRect(in sheetFrame: CGRect, section: Int) -> CGRect {
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

  func drawColumn(rect: CGRect, i: Int, of: Int, name: String?, textColor: UIColor, backgroundColor: UIColor?, style: UIButton.Style, headerFrame: CGRect, createButton: (() -> UIButton)) {
    let columnWidth = rect.width / CGFloat(of)
    let ti = CGFloat(i)
    let columnFrame = CGRect(
      origin: CGPoint(
        x: rect.minX + columnWidth * ti,
        y: headerFrame.maxY
      ),
      size: CGSize(
        width: columnWidth - (gutter + (CGFloat(of) - 1) * ti),
        height: rect.height - headerFrame.height
      )
    )
    let background = UIView(frame: columnFrame)
    background.backgroundColor = backgroundColor
    background.layer.cornerRadius = 4
    addSubview(background)

    let columnLabel = UILabel(
      frame: CGRect(
        origin: CGPoint(
          x: columnFrame.minX,
          y: columnFrame.minY + 4
        ),
        size: CGSize(
          width: columnFrame.width,
          height: 16
        )
      )
    )
    columnLabel.text = name?.uppercased()
    columnLabel.font = UIFont.systemFont(ofSize: 12)
    columnLabel.textAlignment = .center
    addSubview(columnLabel)
    columnLabel.textColor = textColor
    states.enumerated().forEach {
      drawButton(
        createButton(),
        in: columnFrame,
        i: $0.offset,
        of: states.count,
        state: $0.element,
        style: style,
        sectionInset: name != nil ? sectionInset : 16
      )
    }
  }


  func drawButton(_ button: UIButton, in themeFrame: CGRect, i: Int, of: Int, state: ButtonStyleTests.State, style: UIButton.Style, sectionInset: CGFloat) {
    let stateHeight = (themeFrame.height - sectionInset) / CGFloat(of)
    let buttonFrame = CGRect(
      origin: CGPoint(
        x: themeFrame.minX,
        y: sectionInset + themeFrame.minY + stateHeight * CGFloat(i)
      ),
      size: CGSize(
        width: themeFrame.width,
        height: stateHeight
      )
    ).inset(by: UIEdgeInsets(equalInsets: gutter))
    button.setTitle(state.rawValue.capitalized, for: .normal)
    button.isEnabled = state != .disabled
    button.isHighlighted = state == .highlighted
    button.frame = buttonFrame
    addSubview(button)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
