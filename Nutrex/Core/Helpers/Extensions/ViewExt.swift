//
//  ViewExt.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

extension View {
    
    // MARK: - LAYOUT -
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    // MARK: - BACKGROUNDS -
    func glassmorphed(_ cornerRadius: CGFloat = 25.0) -> some View {
        self.modifier(GlassEffectModifier(cornerRadius))
    }
    
    func carded(_ cornerRadius: CGFloat = 16.0) -> some View {
        self.modifier(CardedModifier(cornerRadius))
    }
    
    func stroked() -> some View {
        self.modifier(StrokedModifier())
    }
    
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    func animationEffect(isSelected: Bool, id: String, in namespace: Namespace.ID) -> some View {
        self.modifier(AnimationEffectModifier(isSelected: isSelected, id: id, namespace: namespace))
    }
    
    func pickerTextStyle(isSelected: Bool) -> some View {
        self.modifier(PickerStyleModifier(isSelected: isSelected))
    }
    
    // MARK: - VIEWS -
    func showAlert<T: NXAlert>(alert: Binding<T?>) -> some View {
        self
            .alert(alert.wrappedValue?.title ?? "Error", isPresented: Binding(value: alert)) {
                alert.wrappedValue?.actions
            } message: {
                if let description = alert.wrappedValue?.description {
                    Text(description)
                }
            }
    }
    
    func loadingView(_ title: String = "Loading...", isLoading: Bool) -> some View {
        self.modifier(LoadingViewModifier(title, isLoading: isLoading))
    }
    
    // MARK: - FONTS -
    func impactFontHeaderStyle(letterSpacing: CGFloat = 0, fontWidth: Font.Width = .standard) -> some View {
    self.modifier(ImpactHeaderFontStyle(letterSpacing: letterSpacing, fontWidth: fontWidth))
}
    
    func headerFontStyle(letterSpacing: CGFloat = 0, fontWidth: Font.Width = .standard) -> some View {
        self.modifier(HeaderFontStyle(letterSpacing: letterSpacing, fontWidth: fontWidth))
    }
    
    func bodyFontStyle(letterSpacing: CGFloat = 0) -> some View {
        self.modifier(BodyFontStyle(letterSpacing: letterSpacing))
    }
    
    func sectionHeaderFontStyle(letterSpacing: CGFloat = 0) -> some View {
        self.modifier(SectionHeaderTitle(letterSpacing: letterSpacing))
    }
    
    func headlineFontStyle(letterSpacing: CGFloat = 0, fontWidth: Font.Width = .standard) -> some View {
        self.modifier(HeadlineFontStyle(letterSpacing: letterSpacing, fontWidth: fontWidth))
    }
    
    func thinBodyFontStyle(letterSpacing: CGFloat = 0, fontWidth: Font.Width = .standard) -> some View {
        self.modifier(ThinBodyFontStyle())
    }
    
    func captionFontStyle(letterSpacing: CGFloat = 0, fontWidth: Font.Width = .standard) -> some View {
        self.modifier(CaptionFontStyle())
    }
    
    func caption2FontStyle(letterSpacing: CGFloat = 0, fontWidth: Font.Width = .standard) -> some View {
        self.modifier(Caption2FontStyle())
    }
    
    func thinCaptionFontStyle(letterSpacing: CGFloat = 0, fontWidth: Font.Width = .standard) -> some View {
        self.modifier(ThinCaptionFontStyle())
    }
    
}
