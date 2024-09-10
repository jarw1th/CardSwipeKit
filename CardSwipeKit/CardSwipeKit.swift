//
//  CardSwipeKit.swift
//  CardSwipeKit
//
//  Created by Руслан Парастаев on 10.09.2024.
//

import SwiftUI

/// A view for displaying and interacting with a stack of cards.
public struct CardSwipeKit<CardData, Content: View>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    @Binding private var isSwipeBack: Bool
    private let cards: [CardData]
    private let isAnimated: Bool
    private let cardView: (CardData) -> Content

    public init(isSwipeBack: Binding<Bool> = .constant(false),
                cards: [CardData],
                isAnimated: Bool = false,
                @ViewBuilder cardView: @escaping (CardData) -> Content) {
        self._isSwipeBack = isSwipeBack
        self.cards = cards
        self.isAnimated = isAnimated
        self.cardView = cardView
        self.viewModel = ViewModel(isAnimated: isAnimated)
    }

    public var body: some View {
        VStack {
            if #available(iOS 17, *) {
                makeBody()
                    .onChange(of: isSwipeBack) { _, val in
                        if val {
                            viewModel.swipeBack()
                            isSwipeBack = false
                        }
                    }
            } else {
                makeBody()
                    .onChange(of: isSwipeBack) { val in
                        if val {
                            viewModel.swipeBack()
                            isSwipeBack = false
                        }
                    }
            }
        }
    }
    
    private func makeBody() -> some View {
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
    
    public func carousel(_ space: CGFloat = 300) -> some View {
        viewModel.type = .carousel
        viewModel.carouselSpace = space
        return self
    }
    
}
