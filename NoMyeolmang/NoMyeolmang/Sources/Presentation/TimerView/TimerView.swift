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
        GeometryReader { geo in
            ZStack {
                SpaceshipView()
                    .offset(y: geo.size.height * 0.15)
                VStack {
                    TimeLeftStopView()
                        .offset(y: geo.size.height * -0.1)
                    
                    Button("Next: Feedback") {
                        coordinator.push(.feedback)
                    }
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
        .frame(width: 800, height: 600)
    }
}

#Preview {
    TimerView()
}
