//
//  CardView.swift
//  CardSwipeKit
//
//  Created by Руслан Парастаев on 10.09.2024.
//

import SwiftUI

/// A view representing a card with a title.
@available(macOS 10.15, *)
public struct CardView: View {
    
    // Title to display on the card
    private var title: String = "CardView"

    /// Initializes a `CardView` with a given title.
    /// - Parameter title: The title text to be displayed on the card.
    public init(title: String) {
        self.title = title
    }
    
    public var body: some View {
        makeBody()
    }
    
    /// Creates the main view layout for the card.
    /// - Returns: A `VStack` containing the card's content and styling.
    private func makeBody() -> some View {
        VStack {
            // Display the title with headline font and padding
            Text(title)
                .font(.headline)
                .padding()
        }
        // Set the card to take maximum available width and height
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // Style the card with a white background, rounded corners, and shadow
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
}
