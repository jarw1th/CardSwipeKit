//
//  CardSwipeKit.swift
//  CardSwipeKit
//
//  Created by Руслан Парастаев on 10.09.2024.
//

import SwiftUI

public struct CardSwipeKit<CardData, Content: View>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    private let cards: [CardData]
    private let isAnimated: Bool
    private let cardView: (CardData) -> Content

    public init(cards: [CardData], 
                isAnimated: Bool = false,
                @ViewBuilder cardView: @escaping (CardData) -> Content) {
        self.cards = cards
        self.isAnimated = isAnimated
        self.cardView = cardView
        self.viewModel = ViewModel(isAnimated: isAnimated)
    }

    public var body: some View {
        ZStack {
            ForEach(cards.indices.reversed(), id: \.self) { index in
                if index >= viewModel.topCardIndex {
                    cardView(cards[index])
                        .offset(x: viewModel.offset(for: index).width, y: viewModel.offset(for: index).height)
                        .scaleEffect(viewModel.scale(for: index))
                        .rotationEffect(viewModel.rotation(for: index))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    viewModel.offset = value.translation
                                }
                                .onEnded { value in
                                    viewModel.handleSwipe(translation: value.translation)
                                }
                        )
                        .animation(.spring(), value: viewModel.offset)
                }
            }
        }
    }
    
    public func deck() -> some View {
        viewModel.type = .deck
        return  self
    }
    
    public func carousel() -> some View {
        viewModel.type = .carousel
        return self
    }
    
}

struct CardDeckView_Previews: PreviewProvider {
    static var previews: some View {
        CardSwipeKit(cards: ["Loh", "Loh1", "d"], cardView: { card in
            CardView(title: card)
        })
        .carousel()
    }
}
