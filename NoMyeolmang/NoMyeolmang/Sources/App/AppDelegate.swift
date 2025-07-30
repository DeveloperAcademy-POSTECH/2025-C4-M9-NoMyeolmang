//
//  AppDelegate.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/30/25.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var statusItem: NSStatusItem?
    var popoverWindowController: PopoverWindowController?
    var moduleFactory: ModuleFactory?
    var coordinator: AppCoordinator?
    
    private let statusBarTimerManager = StatusBarDisplay()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.setupStatusItem()
            self?.statusBarTimerManager.startObserving(statusItem: self?.statusItem)
        }
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(named: "menuIcon")
            button.action = #selector(togglePopover(_:))
            button.target = self
            button.image?.isTemplate = true
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        guard let button = statusItem?.button else { return }
        
        guard let moduleFactory = moduleFactory,
              let coordinator = coordinator else {
            print("ModuleFactory or Coordinator not ready")
            return
        }
        
        if let popover = popoverWindowController, popover.isShown {
            popover.close()
        } else {
            let rootView = PopoverRootView(moduleFactory: moduleFactory)
                .environmentObject(coordinator)
            
            popoverWindowController = PopoverWindowController(rootView: rootView)
            popoverWindowController?.show(relativeTo: button)
        }
    }
    
    deinit {
        statusBarTimerManager.stop()
    }
}
