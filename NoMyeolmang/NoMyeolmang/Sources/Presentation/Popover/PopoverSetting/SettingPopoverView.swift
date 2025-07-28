//
//  SettingPopoverView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/27/25.
//

import SwiftUI

struct SettingPopoverView: View {
    @State private var isRecommendedTimeSelected: Bool = true
    
    var body: some View {
        VStack {
            PopoverToggleView(isRecommendedTimeSelected: $isRecommendedTimeSelected)
                .padding(.top, 16)
                .padding(.bottom, 57)
            
            PopoverTimerSettingView(isRecommendedTimeSelected: $isRecommendedTimeSelected)
                .padding(.bottom, 65)

            Button {
                print("다음으로 버튼 눌림!")
            } label: {
                Text("다음으로")
                    .modifier(PopoverButtonModifier())
            }
            .buttonStyle(.plain)
            .padding(.bottom, 20)
        }
        .frame(width: 230, height: 270)
        .background(Color.white.opacity(0.0001))
        .background(Color("E2E2E2").opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.15),
                radius: 4, x: 0, y: 2)
        .shadow(color: .black.opacity(0.18),
                radius: 15, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.5), lineWidth: 0.5)
                .blur(radius: 1)
                .offset(x: 0, y: 0.5)
                .mask(RoundedRectangle(cornerRadius: 10))
        )
        .background(
            .ultraThinMaterial
        )
    }
}

#Preview {
    SettingPopoverView()
}
