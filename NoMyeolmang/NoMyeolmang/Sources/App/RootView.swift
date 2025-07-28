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
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
        
    var body: some View {
        let repository = SwiftDataUserTrainingDataRepository(context: context)
        let predictor = FocusScorePredictor(model: ModelLoader.loadModel()!)
        let personalizater = FocusPersonalizater(modelURL: ModelLoader.loadModelURL())
        
        let timerViewModel = TimerViewModel(predictor: predictor, repository: repository)
        let feedbackViewModel = FeedbackViewModel(repository: repository, personalizater: personalizater)
        let timerSettingViewModel = TimerSettingViewModel()
        let reportViewModel = ReportViewModel()
        
        if hasSeenOnboarding {
            NavigationStack(path: $coordinator.path) {
                TimerSettingView(viewModel: timerSettingViewModel)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .timerSetting:
                            TimerSettingView(viewModel: timerSettingViewModel)
                        case .timer:
                            TimerView(viewModel: timerViewModel)
                        case .feedback:
                            FeedbackView(viewModel: feedbackViewModel)
                        case .report:
                            ReportView(viewModel: reportViewModel)
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
