//
//  PopoverRootView.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/29/25.
//

import SwiftUI

struct PopoverRootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    private let moduleFactory: ModuleFactoryProtocol
    
    init(moduleFactory: ModuleFactoryProtocol) {
        self.moduleFactory = moduleFactory
    }
    
    var body: some View {
        NavigationStack(
            path: Binding(
                get: { coordinator.path },
                set: { coordinator.path = $0 }
            )
        ) {
            moduleFactory.makeSettingPopoverView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .timerSetting: moduleFactory.makeSettingPopoverView()
                    case .timer: moduleFactory.makeTimerPopoverView()
                    case .feedback: moduleFactory.makeFeedbackPopoverView()
                    case .report: moduleFactory.makeReportPopoverView()
                    }
                }
        }
        .frame(width: 230, height: 270)
    }
}
