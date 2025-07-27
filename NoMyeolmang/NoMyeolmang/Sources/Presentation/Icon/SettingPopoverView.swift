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
            PopoverToggleView(isRecommendedTimeSelected: true)
            
            Text("반복 학습에 적합한 시간")
                .textStyle(GSFont.Regular12)
                .foregroundStyle(Color.white)

            Text("30분")
                .textStyle(GSFont.SemiBold24)
                .foregroundStyle(Color.white)
            
            Button {
                print("다음으로 버튼 눌림!")
            } label: {
                Text("다음으로")
                    .modifier(PopoverButtonModifier())
            }
            .buttonStyle(.plain)
        }
        .background(Color.black)
    }
}

#Preview {
    SettingPopoverView()
}
