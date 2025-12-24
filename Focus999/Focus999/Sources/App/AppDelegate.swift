//
//  AppDelegate.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/30/25.
//

import Cocoa
import SwiftUI

/// # ``timé/AppDelegate``
///
/// macOS 상태 바 아이템과 팝오버를 관리하는 애플리케이션 델리게이트입니다.
///
/// ## Overview
///
/// `AppDelegate`는 macOS 상태 바에 타이머 아이콘을 표시하고, 클릭 시 팝오버 인터페이스를 제공합니다.
/// ``StatusBarDisplay``를 통해 실시간 타이머 정보를 상태 바에 표시하며, ``PopoverWindowController``를
/// 사용하여 팝오버 창을 관리합니다.
///
/// ## Topics
///
/// ### Status Bar Management
///
/// - ``togglePopover(_:)``
class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var statusItem: NSStatusItem?
    var popoverWindowController: PopoverWindowController?
    var moduleFactory: ModuleFactory?
    var coordinator: AppCoordinator?
    
    private let statusBarTimerManager = StatusBarDisplay()
    
    func applicationDidFinishLaunching(_: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.setupStatusItem()
            self?.statusBarTimerManager.startObserving(statusItem: self?.statusItem)
        }
    }
    
    /// 상태 바 아이템을 설정하고 메뉴 아이콘과 액션을 연결합니다.
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(named: "menuIcon")
            button.action = #selector(togglePopover(_:))
            button.target = self
            button.image?.isTemplate = true
        }
    }
    
    /// 상태 바 아이템 클릭 시 팝오버를 토글합니다.
    @objc func togglePopover(_: AnyObject?) {
        guard let button = statusItem?.button else { return }
        
        guard let moduleFactory,
              let coordinator
        else {
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
