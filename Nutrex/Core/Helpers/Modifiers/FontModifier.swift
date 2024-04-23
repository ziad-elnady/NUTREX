//
//  FontModifier.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 06/04/2024.
//

import SwiftUI

struct ImpactHeaderFontStyle: ViewModifier {
    var letterSpacing: CGFloat = 0
    var fontWidth: Font.Width = .standard
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Impact", size: 48, relativeTo: .largeTitle))
            .fontWeight(.heavy)
            .fontWidth(fontWidth)
            .kerning(letterSpacing)
    }
}

struct HeaderFontStyle: ViewModifier {
    var letterSpacing: CGFloat = 0
    var fontWidth: Font.Width = .standard
    
    func body(content: Content) -> some View {
        content
            .font(.system(.largeTitle, design: .rounded, weight: .heavy))
            .kerning(letterSpacing)
            .fontWidth(fontWidth)
    }
}

struct HeadlineFontStyle: ViewModifier {
    var letterSpacing: CGFloat = 0
    var fontWidth: Font.Width = .standard
    
    func body(content: Content) -> some View {
        content
            .font(.system(.title2, design: .rounded, weight: .medium))
            .fontWeight(.semibold)
            .kerning(letterSpacing)
            .fontWidth(fontWidth)
    }
}

struct BodyFontStyle: ViewModifier {
    var letterSpacing: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .rounded, weight: .regular))
            .kerning(letterSpacing)
    }
}

struct SectionHeaderTitle: ViewModifier {
    var letterSpacing: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .rounded, weight: .semibold))
            .kerning(letterSpacing)
    }
}

struct ThinBodyFontStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .rounded, weight: .thin))
    }
}

struct CaptionFontStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.caption, design: .rounded))
    }
}

struct ThinCaptionFontStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.caption, design: .rounded, weight: .thin))
    }
}

struct Caption2FontStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.caption2, design: .rounded))
    }
}

/*
 Text("Cochin font - fixedSize 18 - relativeTo body")
     .font(.custom("Impact", size: 18, relativeTo: .body))
 
 VStack(alignment: .leading, spacing: 20) {

          Text("design: .default size 18, font weigth medium")
              .font(.system(size: 18, weight: .regular, design: .default))

             Text("design: .default")
                 .font(.system(.body, design: .default))

             Text("design: .serif")
                 .font(.system(.body, design: .serif))

             Text("design: .monospaced")
                 .font(.system(.body, design: .monospaced))

             Text("design: .rounded")
                 .font(.system(.body, design: .rounded))

             Text("design: .rounded, font weight: heavy")
                 .font(.system(.body, design: .rounded))
                 .fontWeight(.heavy)
 }
 
 VStack {
     Text("pattern       dot")
         .strikethrough(pattern: .dot)
     Text("color pink")
        .strikethrough(pattern: .dash color: .pink)
     Text("pattern dot")
        .underline(pattern: .dot, color: .accentColor)
 }
 
 HStack {
     VStack(alignment: .leading) {
         Text("default")
         Text("monospacedDigit").monospacedDigit()
     }

     VStack(alignment: .leading) {
         Text("1234567890")
         Text("1234567890").monospacedDigit()
     }
 }
 
 VStack {
     Text("Kerning Text - 2")
     .kerning(2)
     
     Text("Tracking Text - 2")
     .tracking(2)
 }
 
 HStack(alignment: .firstTextBaseline) {
         Text("some text")
         Text("baselineOffset").baselineOffset(15)
         Text("set")
         Text("to").baselineOffset(15).underline()
         Text("15").underline()
 }
 
 VStack(alignment: .leading, spacing: 5) {
         Text("expanded")
             .fontWidth(.expanded)
         Text("standard")
             .fontWidth(.standard)
         Text("condensed")
             .fontWidth(.condensed)
         Text("compressed")
             .fontWidth(.compressed)
     }
 */
