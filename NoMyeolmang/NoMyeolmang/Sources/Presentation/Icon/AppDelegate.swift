//
//  AppDelegate..swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/25/25.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover = NSPopover()
    var countdownTimer: Timer?
    var remainingSeconds: Int = 30 * 60

    func applicationDidFinishLaunching(_ notification: Notification) {
        popover.contentSize = NSSize(width: 230, height: 270)
        popover.behavior = .transient
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(
            rootView: PopoverView(onStart: {
                self.popover.performClose(nil)
                self.startCountdown()
            })
        )

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "상단바 아이콘 변경 예정")
            button.action = #selector(togglePopover(_:))
            button.target = self
            button.image?.isTemplate = true
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        guard let button = statusItem?.button else { return }
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.contentSize = NSSize(width: 230, height: 270)
            popover.show(relativeTo: .zero, of: button, preferredEdge: .minY)
        }
    }
    func startCountdown() {
        updateStatusItemTitle()

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.remainingSeconds -= 1
            self.updateStatusItemTitle()

            if self.remainingSeconds <= 0 {
                self.countdownTimer?.invalidate()
                self.statusItem?.button?.title = "Done" // 타이머 끝나면 어떻게 보여줄건지 확인하기
            }
        }
    }

    func updateStatusItemTitle() {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        statusItem?.button?.title = String(format: "%02d:%02d", minutes, seconds)
    }
}
