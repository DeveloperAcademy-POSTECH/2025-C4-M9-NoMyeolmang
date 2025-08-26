//
//  VirtualTimerManager.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/22/25.
//

import Foundation

/// # ``timé/VirtualTimerManager``
///
/// 사용자의 집중도에 따라 속도가 조절되는 가상 타이머를 관리합니다.
///
/// `VirtualTimerManager`는 ``FocusLevel``에 따라 틱 간격이 동적으로 변경되는 타이머입니다.
/// 사용자의 집중도가 높을 때는 더 빠르게, 낮을 때는 더 느리게 시간이 흐르도록 
/// 실시간으로 속도를 조절합니다. ``ActualTimerManager``와 비교하여 집중도 효과를 시각화합니다.
///
/// ### Managing Virtual Timer
///
/// - ``start(interval:repeats:)``
/// - ``stop()``
/// - ``updateInterval(to:)``
///
/// ### Monitoring Virtual Progress
///
/// - ``onTick``
/// - ``isRunning``
final class VirtualTimerManager {
    // MARK: Singleton
    static let shared = VirtualTimerManager()
    private init() {}

    // MARK: Properties
    private var timer: Timer?
    private var interval: TimeInterval = 1.0
    private var isRepeating: Bool = true
    var count: Int = 0

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
