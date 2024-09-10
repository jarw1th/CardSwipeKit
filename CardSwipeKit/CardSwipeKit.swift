//
//  CardSwipeKit.swift
//  CardSwipeKit
//
//  Created by Руслан Парастаев on 10.09.2024.
//

import SwiftUI

public struct CardSwipeKit<CardData, Content: View>: View {
    
    @State private var offset: CGSize = .zero
    @State private var topCardIndex: Int = 0
    private let cards: [CardData]
    private let cardView: (CardData) -> Content
    private let withAnimation: Bool

    public init(cards: [CardData], 
                @ViewBuilder cardView: @escaping (CardData) -> Content,
                withAnimation: Bool = false) {
        self.cards = cards
        self.cardView = cardView
        self.withAnimation = withAnimation
    }

    public var body: some View {
        ZStack {
            ForEach(cards.indices.reversed(), id: \.self) { index in
                if index >= topCardIndex {
                    cardView(cards[index])
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
        let swipeThreshold: CGFloat = 100

        if abs(translation.width) > swipeThreshold {
            if withAnimation {
                let swipeDirection: CGFloat = translation.width > 0 ? 1 : -1
                SwiftUI.withAnimation {
                    offset = CGSize(width: swipeDirection * 1000, height: translation.height)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    topCardIndex += 1
                    offset = .zero
                }
            } else {
                topCardIndex += 1
                offset = .zero
            }
        } else {
            SwiftUI.withAnimation {
                offset = .zero
            }
        }
    }
}

struct CardDeckView_Previews: PreviewProvider {
    static var previews: some View {
        CardSwipeKit(cards: ["Loh", "Loh1", ""], cardView: { card in
            CardView(title: card)
        })
        .frame(width: 300, height: 400)
    }
}
