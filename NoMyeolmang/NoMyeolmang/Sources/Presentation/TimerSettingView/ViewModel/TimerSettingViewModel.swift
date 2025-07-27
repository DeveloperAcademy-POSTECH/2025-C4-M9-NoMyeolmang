//
//  TimerSettingViewModel.swift
//  NoMyeolmang
//
//  Created by Moo on 7/27/25.
//

import Foundation

enum TabType {
    case recommended
    case personal
}

@MainActor
final class TimerSettingViewModel: ObservableObject {
    @Published var selectedTab: TabType = .recommended
    @Published var goalTime: Int = 30
    
    var isRecommendedSelected: Bool {
        selectedTab == .recommended
    }
    
    func startFocusSession() {
        ActualTimerManager.shared.setGoalTime(newGoalTime: goalTime*60)
    }
}
