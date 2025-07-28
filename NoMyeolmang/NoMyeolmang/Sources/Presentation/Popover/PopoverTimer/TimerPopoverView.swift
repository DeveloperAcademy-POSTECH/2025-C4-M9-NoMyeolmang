//
//  TimerPopoverView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/27/25.
//

import SwiftUI

struct TimerPopoverView: View {
    var onStart: () -> Void
    var onStop: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            PopoverTimeLeftView(remainingTime: "05 : 30")
            PopoverTimerStopButton {
                print("버튼 눌림!")
                onStart()
            }
            .padding(.top, 60)
            .padding(.bottom, 20)
        }
        .modifier(PopoverBgModifier())
    }
}
