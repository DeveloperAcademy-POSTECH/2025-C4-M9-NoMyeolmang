//
//  FocusTimeSetting.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/25/25.
//

import SwiftUI

struct FocusTimeSetting: View {
    
    var body: some View {
        let boxSize = CGSize(width: 329, height: 161)
        
        VStack(spacing: 0) {
            Text("반복 학습에 적합한 시간")
                .textStyle(GSFont.Regular16)
                .foregroundColor(.white)
                .padding(.top, 52.5)
            
            Text("30분") // 시간 받아와야함
                .textStyle(GSFont.SemiBold24)
                .foregroundColor(.white)
                .padding(.top, 4)
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
    FocusTimeSetting()
}
