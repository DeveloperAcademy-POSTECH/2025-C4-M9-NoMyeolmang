//
//  PopoverTimerStopButton.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct PopoverTimerStopButton: View {
    let onStop: () -> Void
    
    var body: some View {
        Button(action: onStop) {
            Image("timerstop")
        }
        .frame(width: 38, height: 38)
        .buttonStyle(.plain)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    PopoverTimerStopButton {
        print("타이머 중지")
    }
}
