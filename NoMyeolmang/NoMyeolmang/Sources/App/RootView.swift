//
//  RootView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            TimerSettingView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .timerSetting:
                        TimerSettingView()
                    case .timer:
                        TimerView()
                    case .feedback:
                        let personalizater = FocusPersonalizater(modelURL: ModelLoader.loadModelURL())
                        let repository = SwiftDataUserTrainingDataRepository(context: context)
                        let viewModel = FeedbackViewModel(repository: repository, personalizater: personalizater)
                        FeedbackView(viewModel: viewModel)
                    case .report:
                        let viewModel = ReportViewModel()
                        ReportView(viewModel: viewModel)
                    }
                }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}
