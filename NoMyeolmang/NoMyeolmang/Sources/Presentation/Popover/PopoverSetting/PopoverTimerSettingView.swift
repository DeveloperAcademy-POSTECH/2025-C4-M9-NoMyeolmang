//
//  PopoverTimerSettingView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/27/25.
//

import SwiftUI

struct PopoverTimerSettingView: View {
    let selectedTab: TabType
    @Binding var goalTime: Int
    @State private var timeInputText: String = ""
    
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
            if selectedTab == .recommended {
                Text("반복 학습에 적합한 시간")
                    .textStyle(GSFont.Regular14)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 4)
                
                Text("\(goalTime)분")
                    .textStyle(GSFont.SemiBold24)
                    .foregroundStyle(Color.white)
            } else {
                Text("시간을 입력해 주세요")
                    .textStyle(GSFont.Regular14)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 4)
                
                HStack(spacing: -0.1) {
                    TextField("", text: $timeInputText)
                        .onChange(of: timeInputText) {
                            let filtered = timeInputText.filter { $0.isNumber }
                            if filtered != timeInputText {
                                timeInputText = filtered
                            }
                            if let time = Int(filtered) {
                                goalTime = time
                            }
                        }
                        .textStyle(GSFont.SemiBold24)
                        .foregroundStyle(Color.white)
                        .textFieldStyle(.plain)
                        .frame(width: 25)
                        .onAppear {
                            if selectedTab == .personal {
                                goalTime = 0
                                timeInputText = ""
                            }
                        }
                    
                    if Int(timeInputText) != nil {
                        Text("분")
                            .textStyle(GSFont.SemiBold24)
                            .foregroundStyle(Color.white)
                    }
                }
            }
        }
    }
}
