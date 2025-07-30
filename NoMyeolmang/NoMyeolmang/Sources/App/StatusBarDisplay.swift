//
//  StatusBarDisplay.swift
//  timé
//
//  Created by Moo on 7/30/25.
//

import Cocoa

final class StatusBarDisplay {
    private var displayTimer: Timer?
    private weak var statusItem: NSStatusItem?
    
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
    
    func stop() {
        displayTimer?.invalidate()
        displayTimer = nil
    }
    
    deinit {
        stop()
    }
}
