//
//  TimerView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack {
            Text("Timer")
                .font(.largeTitle)

            Button("Next: Feedback") {
                coordinator.push(.feedback)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
