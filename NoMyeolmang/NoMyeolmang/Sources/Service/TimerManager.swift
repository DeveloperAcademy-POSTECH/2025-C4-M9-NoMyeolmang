//
//  TimeManager.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/21/25.
//

import Combine
import Foundation

final class TimerManager {
    private var timer: AnyCancellable?
    private var interval: TimeInterval
    var actualElapsedTime: TimeInterval = 0
    var virtualFocusTime: TimeInterval = 0
    var focusLevel: FocusLevel = FocusLevel.lv4
    var isRunning: Bool = false
    var goalTime: TimeInterval = 0

    init(interval: TimeInterval = 0.5) {
        self.interval = interval
    }

    func start() {
        clear()  // 중복 방지
        timer =
            Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.actualElapsedTime += self.interval
                self.virtualFocusTime += self.focusLevel.convertedTime()
            }
    }

    func clear() {
        timer?.cancel()
        timer = nil
        self.actualElapsedTime = 0
        self.virtualFocusTime = 0
    }

}
