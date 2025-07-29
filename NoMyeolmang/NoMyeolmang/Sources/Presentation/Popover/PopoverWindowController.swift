//
//  PopoverWindowController.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import AppKit
import SwiftUI

class PopoverWindowController: NSObject {
    private var popover: NSPopover
    
    init(rootView: some View) {
        let hostingController = NSHostingController(rootView: rootView)
        
        popover = NSPopover()
        popover.contentSize = NSSize(width: 230, height: 270)
        popover.behavior = .transient
        popover.contentViewController = hostingController
        popover.appearance = NSAppearance(named: .vibrantDark)
        
        super.init()
    }
    
    func show(relativeTo button: NSButton) {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }
    
    func close() {
        popover.performClose(nil)
    }
    
    var isShown: Bool {
        return popover.isShown
    }
}
