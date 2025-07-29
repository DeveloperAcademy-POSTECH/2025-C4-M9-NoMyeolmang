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
    var countdownTimer: Timer?
    var remainingSeconds: Int = 30 * 60
    var popoverWindowController: PopoverWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "상단바 아이콘 변경 예정, 확정 시 의미 담기")
            button.action = #selector(togglePopover(_:))
            button.target = self
            button.image?.isTemplate = true
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        guard let button = statusItem?.button else { return }

            if let window = popoverWindowController?.window, window.isVisible {
                window.orderOut(nil)
            } else {
                let rootView = PopoverRootView(
                    onClick: {
                        self.popoverWindowController?.window?.orderOut(nil)
                        // 타이머 시작 흐름
                        print("onClick")
                    }
                )

                popoverWindowController = PopoverWindowController(rootView: rootView)

                if let window = popoverWindowController?.window,
                   let screen = button.window?.screen {
                    
                    let buttonRect = button.convert(button.bounds, to: nil)
                    let buttonOrigin = button.window?.convertPoint(toScreen: buttonRect.origin) ?? .zero

                    let popupX = buttonOrigin.x
                    let popupY = buttonOrigin.y

                    window.setFrameTopLeftPoint(NSPoint(x: popupX, y: popupY))
                    window.makeKeyAndOrderFront(nil)
                }
            }
    }
    
    func startCountdown() {
        if countdownTimer != nil {
            return
        }

        updateStatusItemTitle()

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.remainingSeconds -= 1
            self.updateStatusItemTitle()

            if self.remainingSeconds <= 0 {
                self.countdownTimer?.invalidate()
                self.countdownTimer = nil
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
