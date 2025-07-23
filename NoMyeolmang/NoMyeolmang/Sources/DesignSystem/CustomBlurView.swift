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
        
        DispatchQueue.main.async {
            applyBlur(to: view, backgroundName: backgroundName, blurRadius: blurRadius, cornerRadius: cornerRadius)
        }
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // 배경이미지 로드 잘 하고 있는지 확인해보기
        guard let nsImage = NSImage(named: NSImage.Name(backgroundName)),
              let tiffData = nsImage.tiffRepresentation,
              let ciImage = CIImage(data: tiffData) else {
            print("배경 이미지 실패: \(backgroundName)")
            return
        }

        let filter = CIFilter.gaussianBlur()
        filter.inputImage = ciImage
        filter.radius = Float(blurRadius)

        let ciContext = CIContext()
        let targetRect = CGRect(origin: .zero, size: nsView.bounds.size)

        if let output = filter.outputImage?.cropped(to: targetRect),
           let cgImage = ciContext.createCGImage(output, from: targetRect) {
            var imageView: NSImageView
            if let existing = nsView.subviews.compactMap({ $0 as? NSImageView }).first {
                imageView = existing
            } else {
                // 이미지는 잘 씌워주고 있는지 확인해보기
                imageView = NSImageView(frame: nsView.bounds)
                imageView.autoresizingMask = [.width, .height]
                nsView.addSubview(imageView, positioned: .below, relativeTo: nil)
                print("NSImageView을 nsView.subviews로 불러오기 실패")
            }
            imageView.image = NSImage(cgImage: cgImage, size: .zero)
            imageView.wantsLayer = true
            imageView.layer?.cornerRadius = cornerRadius
            imageView.layer?.masksToBounds = true
        } else {
            print("Blur 실패: \(backgroundName)")
        }

        // 오버레이는 로드는 잘 하고 있는지 확인해보기
        var overlay: NSView
        if let existing = nsView.subviews.last(where: { !($0 is NSImageView) }) {
            overlay = existing
        } else {
            overlay = NSView(frame: nsView.bounds)
            overlay.autoresizingMask = [.width, .height]
            nsView.addSubview(overlay)
            print("nsView.subviews에 오버레이 추가 성공")
        }
        overlay.wantsLayer = true
        overlay.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.14).cgColor
        overlay.layer?.cornerRadius = cornerRadius
        overlay.layer?.masksToBounds = true
    }
}

private func applyBlur(to view: NSView, backgroundName: String, blurRadius: CGFloat, cornerRadius: CGFloat) {
    guard let url = Bundle.main.url(forResource: backgroundName, withExtension: "png"),
          let ciImage = CIImage(contentsOf: url) else { return }

    let filter = CIFilter.gaussianBlur()
    filter.inputImage = ciImage
    filter.radius = Float(blurRadius)

    let context = CIContext()
    let targetRect = CGRect(origin: .zero, size: view.bounds.size)
    if let output = filter.outputImage?.cropped(to: targetRect),
       let cgImage = context.createCGImage(output, from: targetRect) {
        let imageView = NSImageView(image: NSImage(cgImage: cgImage, size: .zero))
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.width, .height]
        imageView.wantsLayer = true
        imageView.layer?.borderWidth = 2
        imageView.layer?.borderColor = NSColor.red.cgColor
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
}
