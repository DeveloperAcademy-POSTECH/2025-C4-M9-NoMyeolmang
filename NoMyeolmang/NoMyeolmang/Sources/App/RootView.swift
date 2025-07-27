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

    private let predictor = FocusScorePredictor(model: ModelLoader.loadModel()!)
    private var repository: UserTrainingDataRepository {
        SwiftDataUserTrainingDataRepository(context: context)
    }

    var body: some View {
        if hasSeenOnboarding {
            NavigationStack(path: $coordinator.path) {
                TimerSettingView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .timer:
                            TimerView(
                                viewModel: TimerViewModel(
                                    predictor: predictor,
                                    repository: repository
                                )
                            )
                        case .feedback:
                            FeedbackView(
                                viewModel: FeedbackViewModel(
                                    repository: repository,
                                    personalizater: FocusPersonalizater(modelURL: ModelLoader.loadModelURL())
                                )
                            )
                        case .report:
                            ReportView(viewModel: ReportViewModel())
                        default:
                            EmptyView()
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
