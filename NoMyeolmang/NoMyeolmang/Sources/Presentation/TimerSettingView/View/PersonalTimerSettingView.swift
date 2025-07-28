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
    @Binding var goalTime: Int
    @State private var newGoalTimeText: String = ""
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximum = 999
        formatter.generatesDecimalNumbers = false
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        let boxSize = CGSize(width: 329, height: 161)

        VStack(spacing: 0) {
            Text("시간을 입력해 주세요")
                .textStyle(GSFont.Regular16)
                .foregroundColor(.white)
                .padding(.top, 52.5)

            HStack(spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    TextField("", text: $newGoalTimeText)
                        .onChange(of: newGoalTimeText) {
                            let filtered = newGoalTimeText.filter { $0.isNumber }
                            if filtered != newGoalTimeText {
                                newGoalTimeText = filtered
                            }
                            // goalTime에 직접 연결
                            if let time = Int(filtered), (10...30).contains(time) {
                                goalTime = time
                            }
                        }
                        .multilineTextAlignment(.center)
                        .textStyle(GSFont.SemiBold24)
                        .foregroundColor(.white)
                        .background(Color.clear)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isTextFieldFocused)
                        .onAppear {
                            isTextFieldFocused = true
                        }
                        .accentColor(.white)
                        .frame(minWidth: 20, minHeight: 32)
                        .fixedSize()

                    if let value = Int(newGoalTimeText) {
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
                    Color("939393").opacity(0.02),
                    Color("A471C8").opacity(0.3)
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

#Preview {
    struct PreviewWrapper: View {
        @State private var goalTime = 30
        
        var body: some View {
            PersonalTimerSettingView(goalTime: $goalTime)
        }
    }
    
    return PreviewWrapper()
}
