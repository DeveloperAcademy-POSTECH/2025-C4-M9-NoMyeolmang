//
//  TimerStopButton.swift
//  NoMyeolmang
//
//  Created by Moo on 7/26/25.
//

import SwiftUI

struct TimerStopButton: View {
    let onStop: () -> Void

    var body: some View {
        Button(action: onStop) {
            Image("timer_stop")
        }
        .buttonStyle(.plain)
        .navigationBarBackButtonHidden()
    }
}

//#Preview {
//    TimerStopButton {
//        print("타이머 중지")
//    }
//}
