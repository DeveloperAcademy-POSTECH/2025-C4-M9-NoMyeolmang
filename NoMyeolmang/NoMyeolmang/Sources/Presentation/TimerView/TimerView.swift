//
//  TimerView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        ZStack {
            SpaceshipView()
            VStack {
                TimeLeftStopView()
                
                Button("Next: Feedback") {
                    coordinator.push(.feedback)
                }
                .navigationBarBackButtonHidden(true)
            }
        }
        .padding()
        .frame(width: 800, height: 600)
    }
}

#Preview {
    TimerView()
}
