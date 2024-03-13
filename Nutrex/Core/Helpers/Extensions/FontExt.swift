//
//  FontExt.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

import SwiftUI

extension Font {
    static func customFont(
        font: NXFonts = .orbitron,
        weight: NXFontStyles = .regular,
        size: NXFontSizes = .body,
        relativeTo: Font.TextStyle = .body,
        isScaled: Bool = true
    ) -> Font {
        let fontName = "\(font.rawValue)-\(weight.rawValue)"
        let fontSize = size.rawValue
        let customFont = Font.custom(fontName, size: fontSize, relativeTo: relativeTo)

        return customFont
    }
}
