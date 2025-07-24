//
//  PopupView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/24/25.
//

import SwiftUI

struct PopupGuideView: View {
    let message: String
    let notice: String
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text(message)
                .textStyle(GSFont.SemiBold20)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 134)
            
            Text(notice)
                .textStyle(GSFont.Light12)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 12)
            
            Spacer()

            NextButtonView(onTap: onNext)
                .padding(.bottom, 47)
        }
        .frame(width: 268, height: 402)
        .background(Color("191735"))
        .cornerRadius(21.775)
        // 색 추가
        .shadow(color: Color(red: 0.12, green: 0.15, blue: 0.53).opacity(0.13), radius: 13.4, x: 0, y: 6.7)
        .overlay(
            // 그림자
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.9), lineWidth: 6.7)
                .blur(radius: 20.1)
                .mask(
                    RoundedRectangle(cornerRadius: 21.775)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.black, .clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                )
            .overlay(
                    // 테두리
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.8), lineWidth: 0.8)
                )
        )
    }
}

#Preview {
    PopupGuideView(
        message: "끊기지 않는 학습 리듬을 위해",
        notice: "눈 깜빡임, 하품 같은 몸의 반응을 분석해\n몰입 상태를 실시간으로 알려드려요.\n집중력이 떨어지는 순간, 다시 몰입을 도와드릴게요.",
        onNext: {}
    ).frame(width: 800, height: 600)
}
