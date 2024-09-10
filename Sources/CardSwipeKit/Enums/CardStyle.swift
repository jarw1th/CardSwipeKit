//
//  CardStyle.swift
//  CardSwipeKit
//
//  Created by Руслан Парастаев on 10.09.2024.
//

import Foundation

/// Enum representing the style of the card deck.
/// This enum helps determine how the cards are displayed in the view.
internal enum CardStyle {
    
    /// A style where cards are stacked on top of each other.
    /// This is typically used for swipeable card decks.
    case deck
    
    /// A style where cards are displayed in a carousel format.
    /// This is used to show cards in a horizontally scrollable view.
    case carousel
    
}
