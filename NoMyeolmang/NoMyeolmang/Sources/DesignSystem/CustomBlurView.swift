//
//  CustomBlurView.swift
//  NoMyeolmang
//
//  Created by 김소원 on 7/23/25.
//

import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

private struct BackgroundImageNameKey: EnvironmentKey {
    static let defaultValue: String = "backgroundSpace"
}

extension EnvironmentValues {
    var backgroundImageName: String {
        get { self[BackgroundImageNameKey.self] }
        set { self[BackgroundImageNameKey.self] = newValue }
    }
}

struct CustomBlurView: NSViewRepresentable {
    var blurRadius: CGFloat = 10.0
    var cornerRadius: CGFloat = 10.0
    @Environment(\.backgroundImageName) private var backgroundName
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        
        // 배경 확정 시 forResource 변경 예정
        guard let url = Bundle.main.url(forResource: backgroundName, withExtension: "png"),
              let ciImage = CIImage(contentsOf: url) else {
            return view
        }
        
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = ciImage
        blurFilter.radius = Float(blurRadius)
        
        let context = CIContext()
        if let output = blurFilter.outputImage,
           let cgImage = context.createCGImage(output, from: ciImage.extent) {
            let imageView = NSImageView(image: NSImage(cgImage: cgImage, size: .zero))
            imageView.frame = view.bounds
            imageView.autoresizingMask = [.width, .height]
            imageView.wantsLayer = true
            imageView.layer?.cornerRadius = cornerRadius
            imageView.layer?.masksToBounds = true
            view.addSubview(imageView)
        }
        
        let overlay = NSView(frame: view.bounds)
        overlay.autoresizingMask = [.width, .height]
        overlay.wantsLayer = true
        overlay.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.14).cgColor
        overlay.layer?.cornerRadius = cornerRadius
        overlay.layer?.masksToBounds = true
        view.addSubview(overlay)
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        
        // 배경 확정 시 forResource 변경 예정
        // 반응형 고려해서 배경이 바뀌거나 크기가 바뀔 때도 적용시키려고 뒀는데,
        // 변화가 크지 않다면 삭제 예정
        guard let url = Bundle.main.url(forResource: backgroundName, withExtension: "png"),
              let ciImage = CIImage(contentsOf: url) else { return }
        
        let filter = CIFilter.gaussianBlur()
        filter.inputImage = ciImage
        filter.radius = Float(blurRadius)
        
        let context = CIContext()
        if let output = filter.outputImage,
           let cgImage = context.createCGImage(output, from: ciImage.extent) {
            if let imageView = nsView.subviews.compactMap({ $0 as? NSImageView }).first {
                imageView.image = NSImage(cgImage: cgImage, size: .zero)
            }
        }
        
        if let overlay = nsView.subviews.last {
            overlay.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.14).cgColor
            overlay.layer?.cornerRadius = cornerRadius
        }
    }
}
