//
//  AnimatedText.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 16/03/2024.
//

import SwiftUI

struct AnimatedText: View {
    let text: String
    let spacingBetweenWords: Double = 6.0
    let animationDuration: Double
    let delayBetweenWords: Double
    
    init(_ text: String, animationDuration: Double = 0.5, delayBetweenWords: Double = 0.1) {
        self.text = text
        self.animationDuration = animationDuration
        self.delayBetweenWords = delayBetweenWords
    }
    
    var body: some View {
        HStack(spacing: spacingBetweenWords) {
            ForEach(wordsWithDelays(), id: \.0) { word, delay in
                AnimatedWord(word: word, animationDuration: animationDuration, delay: delay)
            }
        }
    }
    
    private func wordsWithDelays() -> [(String, Double)] {
        let words = text.split(separator: " ").map(String.init)
        var delay = 0.0
        var result: [(String, Double)] = []
        for word in words {
            result.append((word, delay))
            delay += delayBetweenWords
        }
        return result
    }
}

struct AnimatedWord: View {
    let word: String
    let animationDuration: Double
    let delay: Double
    
    @State private var startAnimation: Bool = false
    
    var body: some View {
        Text(word)
            .opacity(startAnimation ? 1 : 0)
            .offset(y: startAnimation ? 0 : 20)
            .onAppear {
                withAnimation(Animation.smooth(duration: animationDuration).delay(delay + 0.5)) {
                    startAnimation = true
                }
            }
    }
}

// MARK: - VIEWS -
extension AnimatedText {
    static func + (lhs: AnimatedText, rhs: AnimatedText) -> some View {
        return HStack(spacing: 4.0) {
            lhs
            rhs
        }
    }
}

#Preview {
    AnimatedText("This is the text", animationDuration: 0.5, delayBetweenWords: 0.1)
    +
    AnimatedText("and another one is", animationDuration: 0.5, delayBetweenWords: 0.1)
}
