//
//  PersonalTimerSettingView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/26/25.
//

import SwiftUI
import Combine

struct PersonalTimerSettingView: View {
    @State private var newGoalTime: Int?
    @State private var inputText: String = ""
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
                    TextField(
                        "",
                        text: $inputText
                    )
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
                    .onChange(of: inputText) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        guard filtered == newValue else { return }
                        if let number = Int(filtered.prefix(3)) {
                            newGoalTime = number
                        } else {
                            newGoalTime = nil
                        }
                    }
                    .onReceive(Just(inputText)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            inputText = filtered
                        }
                    }

                    if newGoalTime != nil {
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
    PersonalTimerSettingView()
}
