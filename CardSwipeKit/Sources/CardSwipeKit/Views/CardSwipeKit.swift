//
//  CardSwipeKit.swift
//  CardSwipeKit
//
//  Created by Руслан Парастаев on 10.09.2024.
//

import SwiftUI

/// A view for displaying and interacting with a stack of cards.
@available(macOS 11.0, *)
public struct CardSwipeKit<CardData, Content: View>: View {
    
    @ObservedObject private var viewModel: ViewModel
    
    // Binding to track whether a swipe-back action is requested
    @Binding private var isSwipeBack: Bool
    
    // Data for the cards to be displayed
    private let cards: [CardData]
    
    // Flag to determine if animations should be used
    private let isAnimated: Bool
    
    // Closure to provide the view for each card
    private let cardView: (CardData) -> Content

    /// Initializes a `CardSwipeKit` view.
    /// - Parameters:
    ///   - isSwipeBack: A binding to a Boolean indicating if a swipe-back action is requested.
    ///   - cards: An array of card data to be displayed.
    ///   - isAnimated: A Boolean indicating whether animations should be used.
    ///   - cardView: A closure to create the view for each card.
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
            if #available(iOS 17, *), #available(macOS 14.0, *) {
                // Use the appropriate .onChange modifier based on iOS version
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
    
    /// Creates the main view for the card stack.
    /// - Returns: A view displaying the stack of cards.
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
    
    /// Configures the view as a card deck.
    /// - Returns: The configured `CardSwipeKit` view.
    public func deck() -> some View {
        viewModel.type = .deck
        return  self
    }
    
    /// Configures the view as a carousel.
    /// - Parameter space: The space between cards in the carousel.
    /// - Returns: The configured `CardSwipeKit` view.
    public func carousel(_ space: CGFloat = 300) -> some View {
        viewModel.type = .carousel
        viewModel.carouselSpace = space
        return self
    }
    
}
