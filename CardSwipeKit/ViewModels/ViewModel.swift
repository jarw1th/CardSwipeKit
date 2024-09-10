//
//  DeckViewModel.swift
//  CardSwipeKit
//
//  Created by Руслан Парастаев on 10.09.2024.
//

import SwiftUI

internal final class ViewModel: ObservableObject {
    
    @Published var offset: CGSize = .zero
    @Published var topCardIndex: Int = 0
    
    var isAnimated: Bool
    var type: CardStyle = .deck
    var carouselSpace: CGFloat = 300
   
    init(isAnimated: Bool) {
        self.isAnimated = isAnimated
    }
   
    func offset(for index: Int) -> CGSize {
        switch type {
        case .deck:
            deckOffset(for: index)
        case .carousel:
            carouselOffset(for: index)
        }
    }
    
    private func deckOffset(for index: Int) -> CGSize {
        guard index == topCardIndex else { return .zero }
        return CGSize(width: offset.width, height: offset.height)
    }
    
    private func carouselOffset(for index: Int) -> CGSize {
        guard index == topCardIndex else { return CGSize(width: CGFloat(index - topCardIndex) * carouselSpace, height: 0) }
        return CGSize(width: offset.width, height: offset.height)
    }

    func scale(for index: Int) -> CGFloat {
        index == topCardIndex ? 1.0 : 0.95
    }

    func rotation(for index: Int) -> Angle {
        let rotation = index == topCardIndex ? Double(offset.width / 20) : 0
        return Angle(degrees: rotation)
    }

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
            withAnimation {
                offset = .zero
            }
        }
    }
    
    func swipeBack() {
        guard topCardIndex > 0 else { return }
        
        withAnimation(.easeInOut) {
            offset = CGSize(width: -1000, height: 0)
            topCardIndex -= 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.offset = .zero
        }
    }
    
}
