# `CardSwipeKit`

`CardSwipeKit` is a SwiftUI view component that allows for the creation of card swipeable interfaces. It supports two layouts—deck and carousel—and includes optional swipe animations and swipe-back functionality.

## Overview

`CardSwipeKit` provides a customizable card-swiping interface in which users can swipe through a deck of cards. The cards can be displayed in either a deck layout or a carousel layout. It also allows swipe-back functionality, enabling the user to return to a previous card with an animated swipe.

### Features

- Customizable card views
- Swipe animations
- Two layout styles: deck and carousel
- Swipe-back functionality
- Bindable properties to control swipe-back actions

## Usage

You can initialize `CardSwipeKit` by providing a list of card data and a view builder for each card. You can optionally enable swipe-back functionality and choose between the `deck` and `carousel` layouts.

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
