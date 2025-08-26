//
//  TimeManager.swift
//  NoMyeolmang
//
//  Updated by ohdodin on 7/22/25.
//

import Foundation
/// # ``timé/ActualTimerManager``
///
/// 실제 시간 기준으로 동작하는 타이머를 관리하여 정확한 세션 시간을 추적합니다.
///
/// `ActualTimerManager`는 사용자가 설정한 목표 시간에 따라 실제 시간 기반의 카운트다운 타이머를 제공합니다.
/// ``VirtualTimerManager``와 함께 사용되어 실제 시간과 집중도에 따른 가상 시간의 차이를 보여줍니다.
/// 목표 시간에 도달하면 자동으로 세션을 완료합니다.
///
/// ### Managing Timer
///
/// - ``start(interval:repeats:)``
/// - ``stop()``
/// - ``setGoalTime(newGoalTime:)``
///
/// ### Monitoring Progress
///
/// - ``onTick``
/// - ``onFinish``
/// - ``lastingTime``
/// - ``isRunning``
final class ActualTimerManager {
    // MARK: Singleton
    static let shared = ActualTimerManager()
    private init() {}

    // MARK: Properties
    private var timer: Timer?
    private var interval: TimeInterval = 1.0
    private var isRepeating: Bool = true
    private var goalTime: Int = 300
    var count: Int = 0

    /// 매 틱마다 현재 카운트를 전달하는 클로저입니다.
    var onTick: ((Int) -> Void)?

    /// 목표 시간 도달 시 호출되는 클로저입니다.
    var onFinish: (() -> Void)?

    // MARK: Public Methods
    /// 지정된 간격으로 타이머를 시작합니다.
    func start(interval: TimeInterval = 1.0, repeats: Bool = true) {
        clear()

        self.interval = interval
        self.isRepeating = repeats
        self.count = 0
        
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

    /// 타이머를 중지하고 상태를 초기화합니다.
    func stop() {
        clear()
    }

    /// 목표 시간을 초 단위로 설정합니다.
    func setGoalTime(newGoalTime: Int) {
        self.goalTime = newGoalTime
        print(self.goalTime)
    }

    /// 타이머 실행 상태를 나타냅니다.
    var isRunning: Bool {
        return timer?.isValid ?? false
    }

    /// 남은 시간을 초 단위로 반환합니다.
    var lastingTime: Int {
        return goalTime - count
    }

    // MARK: Private Methods
    private func clear() {
        timer?.invalidate()
        timer = nil
    }
}
