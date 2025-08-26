//
//  CameraManager.swift
//  NoMyeolmang
//
//  Created by Moo on 7/21/25.
//

import AVFoundation

/// # ``timé/CameraManager``
///
/// 디바이스 카메라에서 실시간 비디오 프레임을 캡처하는 매니저입니다.
///
/// `CameraManager`는 AVCaptureSession을 관리하여 비디오 프레임을 실시간으로 캡처합니다. 
/// 캡처된 각 프레임은 `CVPixelBuffer` 형태로 ``AnalysisManager``에 전달되어 Vision 분석에 사용됩니다.
/// 모든 프레임 처리는 전용 백그라운드 큐에서 수행되어 UI 성능에 영향을 주지 않습니다.
///
/// > Important: 카메라 사용을 위해서는 사용자의 카메라 접근 권한이 필요합니다. Info.plist에 NSCameraUsageDescription을 추가하고, 앱 실행 시 자동으로 권한을 요청합니다.
///
/// ### Managing Capture Session
///
/// - ``start()``
/// - ``stop()``
///
/// ### Handling Video Frames
///
/// - ``onFrame``
final class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    /// 새로운 비디오 프레임이 캡처될 때마다 호출되는 클로저입니다.
    var onFrame: ((CVPixelBuffer) -> Void)?

    override init() {
        super.init()
        setupSession()
    }

    /// 카메라 권한을 요청하고 비디오 캡처 세션을 시작합니다.
    func start() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                self.session.startRunning()
            }
        }
    }

    /// 비디오 캡처 세션을 중지합니다.
    func stop() {
        session.stopRunning()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        onFrame?(pixelBuffer)
    }
    
    private func setupSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        session.beginConfiguration()
        if session.canAddInput(input) { session.addInput(input) }
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.frame.queue"))
        if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }
        session.commitConfiguration()
    }
}
