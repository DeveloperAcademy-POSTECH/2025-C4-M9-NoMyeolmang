//
//  TimerView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    @State private var formattedTime: String = "30:00"
    @State private var focusLevel: FocusLevel = .lv1
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                TimerBackgroundView(animationDuration: focusLevel.backgroundDuration())
                
                SpaceshipView()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .center, spacing: 32) {
                    TimeLeftView(remainingTimeText: formattedTime)
                    
                    TimerStopButton {
                        coordinator.replaceLast(with: .timerSetting)
                    }
                    Button("Next: Feedback") {
                        coordinator.push(.feedback)
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TimerView()
}
