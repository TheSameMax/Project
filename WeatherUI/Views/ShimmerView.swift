//
//  ShimmerView.swift
//  WeatherUI
//
//  Created by Максим Попов on 28.12.2024.
//

import SwiftUI

struct ShimmerView: View {
    @State private var offset: CGFloat = -1.0

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 150)
            .overlay(
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.white, Color.gray.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                    .mask(Rectangle())
                    .offset(x: offset)
                    .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: offset)
            )
            .onAppear {
                offset = UIScreen.main.bounds.width
            }
    }
}
