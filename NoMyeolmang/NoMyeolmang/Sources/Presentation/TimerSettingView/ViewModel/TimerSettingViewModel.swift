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
    @Published var goalTime: Int = 30 {
        didSet {
            validateGoalTime()
        }
    }
    @Published private(set) var isValid: Bool = true

    var isRecommendedSelected: Bool {
        selectedTab == .recommended
    }

    init() {
        validateGoalTime()
    }

    func selectTab(_ tab: TabType) {
        selectedTab = tab
        validateGoalTime()
    }

    private func validateGoalTime() {
        if selectedTab == .recommended {
            isValid = true
        } else {
            isValid = (10...30).contains(goalTime)
        }
    }

    func startFocusSession() {
        ActualTimerManager.shared.setGoalTime(newGoalTime: goalTime * 60)
    }
}
