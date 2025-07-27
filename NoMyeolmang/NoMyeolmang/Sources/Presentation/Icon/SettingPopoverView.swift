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
            
            GSButton(title: "다음으로", width: 160) {
                print("다음!")
            }
        }
        .background(Color.blue)
    }
}

#Preview {
    SettingPopoverView()
}
