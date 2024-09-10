//
//  CardView.swift
//  CardSwipeKit
//
//  Created by Руслан Парастаев on 10.09.2024.
//

import SwiftUI

public struct CardView: View {
    
    private var title: String = "CardView"

    public init(title: String) {
        self.title = title
    }
    
    public var body: some View {
        makeBody()
    }
    
    private func makeBody() -> some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
}
