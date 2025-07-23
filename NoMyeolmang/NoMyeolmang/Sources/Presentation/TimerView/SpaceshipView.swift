//
//  SpaceshipView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/23/25.
//

import SwiftUI

struct SpaceshipView: View {
    @State private var isShowing = false
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        VStack {
            if isShowing {
                Image("spaceship")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 500)
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            withAnimation(
                .spring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.5)
            ) {
                isShowing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(
                    .spring(
                        response: 0.4,
                        dampingFraction: 0.4,
                        blendDuration: 0.5
                    )
                ) {
                    offsetY = 30
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(
                        .spring(
                            response: 0.4,
                            dampingFraction: 0.5,
                            blendDuration: 0.5
                        )
                    ) {
                        offsetY = 0
                    }
                }
            }
        }
    }
}

#Preview {
    SpaceshipView()
}
