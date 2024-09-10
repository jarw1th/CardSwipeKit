# `CardSwipeKit`

`CardSwipeKit` is a SwiftUI view component designed for creating interactive card-swipe interfaces. It supports multiple card layouts, swipe animations, and swipe-back functionality.

## Overview

`CardSwipeKit` simplifies the creation of swipeable card interfaces in SwiftUI. Cards can be arranged in two styles: **deck** and **carousel**, each offering a unique user experience. It supports swipe-back functionality and smooth animations to enhance interactivity.

### Features

- Customizable card views
- **Deck** and **Carousel** layout styles
- Optional swipe animations
- Swipe-back functionality with binding support
- Easy integration with SwiftUI

## Usage

You can initialize `CardSwipeKit` by providing a list of card data and a view builder for each card. You can optionally enable swipe-back functionality and choose between the `deck` and `carousel` layouts.

### Example

```swift
struct ContentView: View {
    @State private var swipeBackEnabled: Bool = false

    var body: some View {
        CardSwipeKit(
            isSwipeBack: $swipeBackEnabled,
            cards: ["Card 1", "Card 2", "Card 3"],
            cardView: { card in
                Text(card)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        )
        .deck() // Set the layout to deck
        .onAppear {
            // Enable swipe-back after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                swipeBackEnabled.toggle()
            }
        }
    }
}
