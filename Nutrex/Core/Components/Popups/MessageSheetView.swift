//
//  MessageSheetView.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 20/03/2024.
//

import SwiftUI

struct SheetMessageContent {
    let title: String
    let message: String
}

struct MessageSheetView: View {
    let content: SheetMessageContent
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundStyle(.green)
                .padding(.trailing)
            
            VStack(alignment: .leading, spacing: 0.0) {
                Text(content.title)
                    .font(.customFont(font: .audiowide, weight: .regular, size: .largeTitle, relativeTo: .largeTitle))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(content.message)
                    .font(.customFont(font: .ubuntu))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    MessageSheetView(content: SheetMessageContent(title: "Congrats!",
                                                  message: "You have successfully registered to NUTREX"))
}
