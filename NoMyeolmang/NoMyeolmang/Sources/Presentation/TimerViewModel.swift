//
//  TimerViewModel.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/20/25.
//

import Combine
import Foundation
import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var remainingTime: Int = 0
    @Published var focusCount: Int = 0
    @Published var focusLevel = FocusLevel.lv4
    private let predictor: FocusScorePredictor

    init() {
        guard let predictor = FocusScorePredictor() else {
            fatalError("⛔️ FocusScorePredictor 인스턴스 생성 실패")
        }
        self.predictor = predictor
        ActualTimerManager.shared.onTick = { [weak self] count in
            self?.remainingTime = ActualTimerManager.shared.lastingTime
            print("tick")
        }
        VertualTimerManager.shared.onTick = { [weak self] count in
            self?.focusCount = count
            print("tock")
        }
        ActualTimerManager.shared.start()
        VertualTimerManager.shared.start()
    }

    func stop() {
        ActualTimerManager.shared.stop()
        VertualTimerManager.shared.stop()
    }

    func updateInterval(for level: FocusLevel) {
        let interval = level.tickSpeed()
        VertualTimerManager.shared.updateInterval(to: interval)
    }

    func predict() {
        guard let result = predictor.run() else {
            print("⛔️ 예측 실패")
            return
        }

        let focusRawvalue = Int(result.rounded())
        if let level = FocusLevel(rawValue: focusRawvalue) {
            updateInterval(for: level)
        }
    }
}
