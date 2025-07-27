//
//  RootView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/20/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @Environment(\.modelContext) private var context
    
    var body: some View {
        if hasSeenOnboarding {
            NavigationStack(path: $coordinator.path) {
                TimerSettingView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .timerSetting:
                            TimerSettingView()
                        case .timer:
                            let predictor = FocusScorePredictor(model: ModelLoader.loadModel()!)
                            let repository = SwiftDataUserTrainingDataRepository(context: context)
                            let viewModel = TimerViewModel(predictor: predictor, repository: repository)
                            TimerView(viewModel: viewModel)
                        case .feedback:
                            let personalizater = FocusPersonalizater(modelURL: ModelLoader.loadModelURL())
                            let repository = SwiftDataUserTrainingDataRepository(context: context)
                            let viewModel = FeedbackViewModel(repository: repository, personalizater: personalizater)
                            FeedbackView(viewModel: viewModel)
                        case .report:
                            ReportView()
                        }
                    }
            }
            .frame(minWidth: 800, minHeight: 600)
        } else {
            OnboardingView(showOnboarding: Binding(
                get: { !hasSeenOnboarding },
                set: { newValue in
                    if !newValue {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        hasSeenOnboarding = true
                    }
                }
            ))
            .frame(minWidth: 800, minHeight: 600)
        }
    }
}
