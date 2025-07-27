//
//  PopoverTimerSettingView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/27/25.
//

import SwiftUI

struct PopoverTimerSettingView: View {
    @Binding var isRecommendedTimeSelected: Bool
    @State private var timeInput = 30
    
    private var numberFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.allowsFloats = false
            formatter.minimum = 10
            formatter.maximum = 30
            return formatter
        }
    
    var body: some View {
        VStack {
            if isRecommendedTimeSelected {
                Text("반복 학습에 적합한 시간")
                    .textStyle(GSFont.Regular12)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 4)
                
                Text("30분")
                    .textStyle(GSFont.SemiBold24)
                    .foregroundStyle(Color.white)
            } else {
                Text("시간을 입력해 주세요")
                    .textStyle(GSFont.Regular12)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 4)
                
                HStack(spacing: -0.1) {
                    TextField("30", value: $timeInput, formatter: numberFormatter)
                        .textStyle(GSFont.SemiBold24)
                        .foregroundStyle(Color.white)
                        .textFieldStyle(.plain)
                        .frame(width: 25)
                        .onChange(of: timeInput) {
                            print(timeInput)
                        }
                    
                    Text("분")
                        .textStyle(GSFont.SemiBold24)
                        .foregroundStyle(Color.white)
                }
            }
        }
    }
}
