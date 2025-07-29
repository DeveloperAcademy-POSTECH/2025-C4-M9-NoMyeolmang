//
//  PopoverRatingButton.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct PopoverRatingButton: View {
    @State var selectedNumber: Int?

    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...5, id: \.self) { number in
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.38))
                        .frame(width: 30)
                        .overlay(
                            selectedNumber == number ? AppGradients.hoverGradient : nil
                        )
                        .clipShape(Circle())
                        .background(Circle().fill(Color.clear)
                            .stroke(Color.white.opacity(0.65), lineWidth: 0.65)
                        )
                        
                    Text("\(number)")
                        .font(.system(size: 12))
                        .bold()
                        .foregroundStyle(Color.white)
                }
                .onTapGesture {
                    selectedNumber = number
                }
            }
        }
    }
}

extension Color {
    static let bPurple = Color("3E154B")
    static let bIndigo = Color("231151")
}

struct AppGradients {
    static let hoverGradient = LinearGradient(
        colors: [.bPurple, .bIndigo],
        startPoint: .top,
        endPoint: .bottom
    )
}

#Preview {
    PopoverRatingButton()
}
