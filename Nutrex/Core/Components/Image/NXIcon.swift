//
//  NXIcon.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

enum NXIconSize: CGFloat {
    case small  = 16.0
    case medium = 24.0
    case large  = 32.0
}

struct NXIcon: View {
    let name: String
    var iconSize: NXIconSize = .medium
    
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: iconSize.rawValue)
    }

}

#Preview {
    NXIcon(name: "google")
}
