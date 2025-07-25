//
//  TimerView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    //@StateObject private var viewModel = TimerViewModel()

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                SpaceshipView()
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
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .background(TimerBackgroundView())
    }
}

#Preview {
    TimerView()
}
