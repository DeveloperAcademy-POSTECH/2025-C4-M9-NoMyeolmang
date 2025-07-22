//
//  BlurView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/21/25.
//

import SwiftUI
import AppKit

struct BlurView: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .hudWindow // .popover, .menu
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = .withinWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
