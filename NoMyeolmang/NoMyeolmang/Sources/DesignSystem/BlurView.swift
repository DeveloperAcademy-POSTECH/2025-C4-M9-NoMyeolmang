//
//  BlurView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/21/25.
//

import SwiftUI
import AppKit

struct BlurView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .hudWindow // .underWindowBackground, .sidebar 등으로 변경 가능하며 엔지와 조율 예정
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
