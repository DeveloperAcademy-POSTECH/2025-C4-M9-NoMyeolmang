//
//  TimerView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var viewModel: TimerViewModel

    init(goalTime: TimeInterval) {
        _viewModel = StateObject(
            wrappedValue: TimerViewModel(goalTime: goalTime)
        )
    }

    var body: some View {
        VStack {
            Text("Timer")
                .font(.largeTitle)
            VStack(spacing: 8) {
                Text("Focus Level 설정하기")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("집중력 단계", selection: $viewModel.focusLevel) {
                    ForEach(FocusLevel.allCases, id: \.self) { level in
                        Text("\(level.rawValue)").tag(level)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 220)

                VStack {
                    Text("실제 타이머")
                    Text(
                        String(
                            format: "%02d:%02d",
                            viewModel.calcActualTime() / 60,
                            viewModel.calcActualTime() % 60
                        )
                    )
                    .font(.title)
                }
                VStack {
                    Text("집중 타이머")
                    Text(
                        String(
                            format: "%02d:%02d",
                            viewModel.calcVirtualTime() / 60,
                            viewModel.calcVirtualTime() % 60
                        )
                    )
                    .font(.title)
                }
            }
            .padding(.top, 4)

            Button("Next: Feedback") {
                coordinator.push(.feedback)
            }
            .navigationBarBackButtonHidden(true)
        }
        .padding()
        .onReceive(viewModel.timer) { _ in
            viewModel.addTime()
        }
    }
}

#Preview {
    TimerView(goalTime: 300)
}
