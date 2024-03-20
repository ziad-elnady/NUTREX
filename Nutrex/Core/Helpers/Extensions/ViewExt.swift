//
//  ViewExt.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

extension View {
    func stroked() -> some View {
        self.modifier(StrokedModifier())
    }
    
    func animationEffect(isSelected: Bool, id: String, in namespace: Namespace.ID) -> some View {
        self.modifier(AnimationEffectModifier(isSelected: isSelected, id: id, namespace: namespace))
    }
    
    func pickerTextStyle(isSelected: Bool) -> some View {
        self.modifier(PickerStyleModifier(isSelected: isSelected))
    }
    
    
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
    
}
