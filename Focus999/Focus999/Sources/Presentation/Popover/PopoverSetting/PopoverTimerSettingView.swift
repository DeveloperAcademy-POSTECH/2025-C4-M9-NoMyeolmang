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
                            let filtered = timeInputText.filter(\.isNumber)
                            let limitedText = String(filtered.prefix(2))
                            
                            if let time = Int(limitedText) {
                                if time > 30 {
                                    goalTime = 30
                                    timeInputText = "30"
                                } else if time == 0 {
                                    goalTime = 10
                                    timeInputText = "10"
                                } else {
                                    goalTime = time
                                    if limitedText != timeInputText {
                                        timeInputText = limitedText
                                    }
                                }
                            } else {
                                goalTime = 0
                                timeInputText = ""
                            }
                        }
                        .onDisappear {
                            if goalTime < 10, goalTime != 0 {
                                goalTime = 10
                                timeInputText = "10"
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
