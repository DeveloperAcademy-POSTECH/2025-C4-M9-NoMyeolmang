//
//  TimerReportBox.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/27/25.
//

import SwiftUI

struct TimerReportBox: View {
    let earthTime: String
    let focusTime: String
    let boxSize = CGSize(width: 345, height: 119)
    
    var body: some View {
        HStack(spacing: 48) {
            VStack(spacing: 2) {
                Text("지구 시간")
                    .textStyle(GSFont.Light14)
                    .foregroundColor(.white)
                Text(earthTime)
                    .textStyle(GSFont.SemiBold28)
                    .foregroundColor(.white)
            }
            Rectangle()
                .fill(Color.white)
                .frame(width: 1, height: 99)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .opacity(0.1)
            VStack(spacing: 2) {
                Text("탐사 시간")
                    .textStyle(GSFont.Light14)
                    .foregroundColor(.white)
                Text(focusTime)
                    .textStyle(GSFont.SemiBold28)
                    .foregroundColor(.white)
            }
        } // hstack
        
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
        .padding(.top, 25)
    }
}

// #Preview {
//    TimerReportBox(earthTime: "10:00", focusTime: "12:34")
// }
