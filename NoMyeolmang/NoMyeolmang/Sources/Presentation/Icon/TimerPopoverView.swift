//
//  TimerPopoverView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/27/25.
//

import SwiftUI

struct TimerPopoverView: View {
    var body: some View {
        VStack {
            Spacer()
            PopoverTimeLeftView()
            PopoverTimerStopButton {
                print("버튼 눌림!")
            }
            .padding(.top, 60)
            .padding(.bottom, 20)
        }
        .frame(width: 230, height: 270)
        .background(
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 230, height: 270)
            .background(Color(red: 0.89, green: 0.89, blue: 0.89).opacity(0.35))

            .background(.white.opacity(0))

            .cornerRadius(10)
            .shadow(color: .black.opacity(0.18), radius: 7.5, x: 0, y: 8)

            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 2)
            .overlay(
            RoundedRectangle(cornerRadius: 10)
            .inset(by: -0.25)
            .stroke(.black.opacity(0.06), lineWidth: 0.5)
            )
            .blur(radius: 40.77423)
        )
    }
}

#Preview {
    TimerPopoverView()
}
