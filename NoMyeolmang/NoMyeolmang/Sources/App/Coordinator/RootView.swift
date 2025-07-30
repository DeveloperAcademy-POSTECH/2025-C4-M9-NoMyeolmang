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
    
    private let moduleFactory: ModuleFactoryProtocol
    
    init(moduleFactory: ModuleFactoryProtocol) {
        self.moduleFactory = moduleFactory
    }
    
    var body: some View {
//        if hasSeenOnboarding {
//            NavigationStack(
//                path: Binding(
//                    get: { coordinator.path },
//                    set: { coordinator.path = $0 }
//                )
//            ) {
//                moduleFactory.makeTimerSettingView()
//                    .navigationDestination(for: AppRoute.self) { route in
//                        switch route {
//                        case .timerSetting: moduleFactory.makeTimerSettingView()
//                        case .timer: moduleFactory.makeTimerView()
//                        case .feedback: moduleFactory.makeFeedbackView()
//                        case .report: moduleFactory.makeReportView()
//                        }
//                    }
//            }
//            .frame(minWidth: 800, minHeight: 600)
//        } else {
            moduleFactory.makeOnboardingView(
                showOnboarding: Binding(
                    get: { !hasSeenOnboarding },
                    set: { newValue in
                        if !newValue {
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            hasSeenOnboarding = true
                        }
                    }
                )
            )
            .frame(minWidth: 800, minHeight: 600)
        }
    }
//}
