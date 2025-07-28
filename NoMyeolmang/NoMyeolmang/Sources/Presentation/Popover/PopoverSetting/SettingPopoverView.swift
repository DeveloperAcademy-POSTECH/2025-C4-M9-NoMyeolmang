//
//  SettingPopoverView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/27/25.
//

import SwiftUI

struct SettingPopoverView: View {
    var onStart: () -> Void
    var onStop: () -> Void
    
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
        .modifier(PopoverBgModifier())
    }
}

