//
//  DeckViewModel.swift
//  CardSwipeKit
//
//  Created by Руслан Парастаев on 10.09.2024.
//

import SwiftUI

/// ViewModel responsible for managing card interactions, including swipe gestures, animations, and card transitions.
@available(macOS 10.15, *)
internal final class ViewModel: ObservableObject {
    
    /// Tracks the current drag offset for card swiping.
    @Published var offset: CGSize = .zero
    
    /// Index of the top card in the deck.
    @Published var topCardIndex: Int = 0
    
    /// Determines if animations should be applied during card interactions.
    var isAnimated: Bool
    
    /// Defines the card layout style (deck or carousel).
    var type: CardStyle = .deck
    
    /// Spacing between cards in the carousel layout.
    var carouselSpace: CGFloat = 300
   
    /// Initializes the ViewModel with the animation setting.
    init(isAnimated: Bool) {
        self.isAnimated = isAnimated
    }
   
    /// Returns the offset for a specific card based on its index and the layout style.
    func offset(for index: Int) -> CGSize {
        switch type {
        case .deck:
            return deckOffset(for: index)
        case .carousel:
            return carouselOffset(for: index)
        }
    }
    
    /// Calculates the offset for a card in deck style, only applying the current offset to the top card.
    private func deckOffset(for index: Int) -> CGSize {
        guard index == topCardIndex else { return .zero }
        return CGSize(width: offset.width, height: offset.height)
    }
    
    /// Calculates the offset for a card in carousel style, positioning cards with specified spacing.
    private func carouselOffset(for index: Int) -> CGSize {
        guard index == topCardIndex else {
            return CGSize(width: CGFloat(index - topCardIndex) * carouselSpace, height: 0)
        }
        return CGSize(width: offset.width, height: offset.height)
    }

    /// Determines the scale of a card, shrinking non-top cards slightly.
    func scale(for index: Int) -> CGFloat {
        index == topCardIndex ? 1.0 : 0.95
    }

    /// Calculates the rotation for a card during a drag, applying rotation only to the top card.
    func rotation(for index: Int) -> Angle {
        let rotation = index == topCardIndex ? Double(offset.width / 20) : 0
        return Angle(degrees: rotation)
    }

    /// Handles swipe gestures and determines if the swipe passes the threshold to move the top card.
    func handleSwipe(translation: CGSize) {
        let swipeThreshold: CGFloat = 100
        
        if abs(translation.width) > swipeThreshold {
            if isAnimated {
                let swipeDirection: CGFloat = translation.width > 0 ? 1 : -1
                withAnimation {
                    offset = CGSize(width: swipeDirection * 1000, height: translation.height)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.topCardIndex += 1
                    self.offset = .zero
                }
            } else {
                topCardIndex += 1
                offset = .zero
            }
        } else {
            // Reset the offset if the swipe does not pass the threshold.
            withAnimation {
                offset = .zero
            }
        }
    }
    
    /// Handles the swipe back gesture, allowing the user to bring back the previous card.
    func swipeBack() {
        guard topCardIndex > 0 else { return }  // Prevent swipe back if at the first card.
        
        // Animate the swipe back.
        withAnimation(.easeInOut) {
            offset = CGSize(width: -1000, height: 0)  // Move the card off-screen to the left.
            topCardIndex -= 1  // Bring back the previous card.
        }
        
        // Reset the offset after the animation.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.offset = .zero
        }
    }
    
}
