//
//  StatusBarDisplay.swift
//  timé
//
//  Created by Moo on 7/30/25.
//

import Cocoa

/// # ``timé/StatusBarDisplay``
///
/// macOS 상태 바에서 실시간 타이머 정보를 표시합니다.
///
/// ## Overview
///
/// `StatusBarDisplay`는 ``ActualTimerManager``의 상태를 모니터링하여 남은 시간을
/// macOS 상태 바에 MM:SS 형식으로 표시합니다. 타이머가 실행 중일 때만 시간을 표시하고,
/// 중지된 상태에서는 빈 문자열을 표시합니다.
///
/// > Important: 모든 UI 업데이트는 메인 스레드에서 수행되어야 하므로, 내부적으로 DispatchQueue.main.async를 사용합니다.
///
/// ## Topics
///
/// ### Display Management
///
/// - ``startObserving(statusItem:)``
/// - ``stop()``
final class StatusBarDisplay {
    private var displayTimer: Timer?
    private weak var statusItem: NSStatusItem?
    
    /// 상태 바 아이템 관찰을 시작하고 실시간 업데이트를 활성화합니다.
    func startObserving(statusItem: NSStatusItem?) {
        self.statusItem = statusItem
        startDisplayTimer()
    }
    
    private func startDisplayTimer() {
        displayTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateDisplay()
            }
        }
    }
    
    private func updateDisplay() {
        guard Thread.isMainThread else { return }
        
        let timerManager = ActualTimerManager.shared
        
        if timerManager.isRunning {
            let remainingSeconds = timerManager.lastingTime
            guard remainingSeconds >= 0 else { return }
            
            let minutes = remainingSeconds / 60
            let seconds = remainingSeconds % 60
            statusItem?.button?.title = String(format: "%02d:%02d", minutes, seconds)
        } else {
            statusItem?.button?.title = ""
        }
    }
    
    /// 타이머 관찰을 중지하고 리소스를 정리합니다.
    func stop() {
        displayTimer?.invalidate()
        displayTimer = nil
    }
    
    deinit {
        stop()
    }
}
