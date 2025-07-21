//
//  TimeManager.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/21/25.
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
    private var count: Int = 0
    private var goalTime: Int = 300

    // 타이머 이벤트 알림
    var onTick: ((Int) -> Void)?

    // MARK: Public Methods
    func start(interval: TimeInterval = 1.0, repeats: Bool = true) {
        clear()

        self.interval = interval
        self.isRepeating = repeats
        self.count = 0

        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: repeats,
            block: { [weak self] _ in
                guard let self else { return }
                self.count += 1
                self.onTick?(self.count)
            }
        )
    }

    func stop() {
        clear()
    }

    var isRunning: Bool {
        return timer?.isValid ?? false
    }
    
    var lastingTime: Int {
        return goalTime - count
    }

    // MARK: Private Methods
    private func clear() {
        timer?.invalidate()
        timer = nil
    }
}

final class VertualTimerManager {
    // MARK: Singleton
    static let shared = VertualTimerManager()
    private init() {}

    // MARK: Properties
    private var timer: Timer?
    private var interval: TimeInterval = 1.0
    private var isRepeating: Bool = true
    private var count: Int = 0

    // 타이머 이벤트 알림
    var onTick: ((Int) -> Void)?

    // MARK: Public Methods
    func start(interval: TimeInterval = 1.0, repeats: Bool = true) {
        clear()

        self.interval = interval
        self.isRepeating = repeats
        self.count = 0

        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: repeats,
            block: { [weak self] _ in
                guard let self else { return }
                self.count += 1
                self.onTick?(self.count)
            }
        )
    }

    func stop() {
        clear()
    }

    func updateInterval(to newInterval: TimeInterval) {
        guard isRunning else {
            self.interval = newInterval
            return
        }
        self.interval = newInterval
        setupTimer()
    }

    var isRunning: Bool {
        return timer?.isValid ?? false
    }

    // MARK: Private Methods
    private func clear() {
        timer?.invalidate()
        timer = nil
    }

    private func setupTimer() {
        clear()
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: isRepeating
        ) { [weak self] _ in
            guard let self else { return }
            self.count += 1
            self.onTick?(self.count)
        }
    }
}
