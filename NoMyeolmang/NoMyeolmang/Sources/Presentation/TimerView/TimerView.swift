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
            ZStack(alignment: .center) {
                SpaceshipView()
                    .offset(y: geo.size.height * 0.15)
                    .frame(maxWidth: .infinity, alignment: .center)
                VStack(alignment: .center) {
                    TimeLeftStopView()
                    Button("Next: Feedback") {
                        coordinator.push(.feedback)
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .background(TimerBackgroundView())
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    TimerView()
}
