//
//  TimeManager.swift
//  NoMyeolmang
//
//  Updated by ohdodin on 7/22/25.
//

import Foundation

final class ActualTimerManager {
    // MARK: Singleton
    static let shared = ActualTimerManager()
    private init() {}

    // MARK: Properties
    private var timer: Timer?
    private var interval: TimeInterval = 1.0
    private var isRepeating: Bool = true
    private var goalTime: Int = 300
    var count: Int = 300

    // 타이머 이벤트 알림
    var onTick: ((Int) -> Void)?

    var onFinish: (() -> Void)?

    // MARK: Public Methods
    func start(interval: TimeInterval = 1.0, repeats: Bool = true) {
        clear()

        self.interval = interval
        self.isRepeating = repeats
        
        // 🔹 타이머 시작 직전에 즉시 1회 호출
        self.onTick?(self.count)

        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: repeats,
            block: { [weak self] _ in
                guard let self else { return }
                self.count += 1
                self.onTick?(self.count)

                if self.count >= self.goalTime {
                    self.onFinish?()
                    self.stop()
                }
            }
        )
    }

    func stop() {
        clear()
    }

    func setGoalTime(newGoalTime: Int) {
        self.goalTime = newGoalTime
        print(self.goalTime)
    }

    var isRunning: Bool {
        return timer?.isValid ?? false
    }

    var lastingTime: Int {
        return goalTime - count
    }

    // MARK: Private Methods
    private func clear() {
        self.count = 0
        timer?.invalidate()
        timer = nil
    }
}
