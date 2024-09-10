//
//  CardSwipeKit.swift
//  CardSwipeKit
//
//  Created by Руслан Парастаев on 10.09.2024.
//

import SwiftUI

// General CardSwipeKit structure
public struct CardSwipeKit<CardData, Content: View>: View {
    
    @State private var offset: CGSize = .zero
    @State private var topCardIndex: Int = 0
    private let cards: [CardData]
    private let cardView: (CardData) -> Content

    public init(cards: [CardData], @ViewBuilder cardView: @escaping (CardData) -> Content) {
        self.cards = cards
        self.cardView = cardView
    }

    public var body: some View {
        ZStack {
            ForEach(cards.indices.reversed(), id: \.self) { index in
                if index >= topCardIndex {
                    cardView(cards[index]) // Pass card data (e.g., title) to CardView
                        .offset(x: self.offset(for: index).width, y: self.offset(for: index).height)
                        .scaleEffect(self.scale(for: index))
                        .rotationEffect(self.rotation(for: index))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.offset = value.translation
                                }
                                .onEnded { value in
                                    self.handleSwipe(translation: value.translation)
                                }
                        )
                        .animation(.spring(), value: offset)
                }
            }
        }
    }

    // Compute card offsets, scale, and rotation based on swipe gestures
    private func offset(for index: Int) -> CGSize {
        guard index == topCardIndex else { return .zero }
        return CGSize(width: offset.width, height: offset.height)
    }

    private func scale(for index: Int) -> CGFloat {
        index == topCardIndex ? 1.0 : 0.95
    }

    private func rotation(for index: Int) -> Angle {
        let rotation = index == topCardIndex ? Double(offset.width / 20) : 0
        return Angle(degrees: rotation)
    }

    private func handleSwipe(translation: CGSize) {
        if abs(translation.width) > 100 {
            topCardIndex += 1
        }
        offset = .zero
    }
}
