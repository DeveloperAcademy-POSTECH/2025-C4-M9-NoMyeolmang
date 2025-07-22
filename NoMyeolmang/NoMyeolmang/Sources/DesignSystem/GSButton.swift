//
//  Button.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/21/25.
//

import SwiftUI

struct GSButton: View {
    let title: String
    let width: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(GSFont.SemiBold20)
                .tracking(-0.32) // 자간 계산 16 × -0.02 = -0.32
                .lineSpacing(6.4) // 행간 계산 16 × 1.4 = 22.4
                .foregroundColor(.white)
                .background(
                    ZStack {
                        BlurView()
                            .frame(width: width, height: 44)
                        Color.white.opacity(0.14)
                    }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                        )
                        .cornerRadius(10)
                )
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 20) {
            GSButton(title: "집중 시작하기", width: 250) {
                print("250 버튼")
            }
            .padding()
            
            GSButton(title: "다음으로", width: 180) {
                print("180 버튼")
            }
            .padding()
        }
    }
}
