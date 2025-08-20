//
//  PopoverRatingButton.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct PopoverRatingButton: View {
    @Binding var selectedIndex: Int?
    @Binding var hoveredIndex: Int?

    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...5, id: \.self) { number in
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.38))
                        .frame(width: 30, height: 30)
                        .overlay(
                            selectedIndex == number ? AppGradients.hoverGradient : nil
                        )
                        .clipShape(Circle())
                        .background(Circle().fill(Color.clear)
                            .stroke(Color.white.opacity(0.65), lineWidth: 0.65)
                            .frame(width: 30, height: 30)
                        )
                        
                    Text("\(number)")
                        .font(.system(size: 12))
                        .bold()
                        .foregroundStyle(Color.white)
                }
                .onHover { hovering in
                    hoveredIndex = hovering ? number : nil
                }
                .onTapGesture {
                    selectedIndex = number
                }
            }
        }
    }
}

extension Color {
    static let bPurple = Color("Purple-900")
    static let bIndigo = Color("Indigo-700")
}

struct AppGradients {
    static let hoverGradient = LinearGradient(
        colors: [.bPurple, .bIndigo],
        startPoint: .top,
        endPoint: .bottom
    )
}
