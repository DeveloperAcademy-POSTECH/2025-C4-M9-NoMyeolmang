//
//  PersonalTimerSettingView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/26/25.
//

import Combine
import Foundation
import SwiftUI

struct PersonalTimerSettingView: View {
    @ObservedObject var viewModel: TimerSettingViewModel
    @Binding var goalTime: Int
    @State private var newGoalTimeText: String = ""
    @FocusState private var isTextFieldFocused: Bool

    var isValidInput: Bool {
        if let time = Int(newGoalTimeText) {
            return (10 ... 30).contains(time)
        }
        return false
    }

    var body: some View {
        let boxSize = CGSize(width: 329, height: 161)

        VStack(spacing: 0) {
            Text("10-30분 설정만 가능해요")
                .textStyle(GSFont.Light12)
                .foregroundColor(Color("Lavender-200"))
                .padding(.top, 24)
            
            Text("시간을 설정해 주세요")
                .textStyle(GSFont.Regular16)
                .foregroundColor(.white)
                .padding(.top, 4)
                .padding(.bottom, 12)

            HStack(spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    TextField("", text: $newGoalTimeText)
                        .onChange(of: newGoalTimeText) {
                            let digitsOnly = newGoalTimeText.filter(\.isNumber)
                            if digitsOnly.count > 2 {
                                newGoalTimeText = String(digitsOnly.prefix(2))
                            } else if digitsOnly != newGoalTimeText {
                                newGoalTimeText = digitsOnly
                            }

                            if let time = Int(newGoalTimeText), (10 ... 30).contains(time) {
                                goalTime = time
                            } else {
                                goalTime = 0
                            }

                            viewModel.validateGoalTime()
                        }
                        .onSubmit {
                            if !isValidInput {
                                newGoalTimeText = ""
                            }
                        }
                        .multilineTextAlignment(.center)
                        .textStyle(GSFont.SemiBold24)
                        .foregroundColor(.white)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isTextFieldFocused)
                        .onAppear {
                            if viewModel.selectedTab == .personal {
                                newGoalTimeText = ""
                                goalTime = 0
                            } else {
                                newGoalTimeText = "\(goalTime)"
                            }

                            viewModel.validateGoalTime()
                            isTextFieldFocused = true
                        }
                        .onChange(of: viewModel.selectedTab) {
                            if viewModel.selectedTab == .personal {
                                newGoalTimeText = ""
                                goalTime = 0
                                viewModel.validateGoalTime()
                            }
                        }

                        .frame(minWidth: 20, minHeight: 32)
                        .fixedSize()

                    if !newGoalTimeText.isEmpty {
                        Text("분")
                            .textStyle(GSFont.SemiBold24)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(width: boxSize.width, height: boxSize.height, alignment: .top)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("Gray-100").opacity(0.02),
                    Color("Purple-300").opacity(0.3),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .opacity(0.4)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.7), lineWidth: 1)
        )
    }
}

// #Preview {
//    struct PreviewWrapper: View {
//        @State private var goalTime = 30
//
//        var body: some View {
//            PersonalTimerSettingView(viewModel: TimerSettingViewModel(), goalTime: $goalTime)
//        }
//    }
//
//    return PreviewWrapper()
// }
