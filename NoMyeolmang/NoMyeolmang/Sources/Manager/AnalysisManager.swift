//
//  AnalysisManager.swift
//  NoMyeolmang
//
//  Created by Moo on 7/21/25.
//

import AVFoundation
import Vision

final class AnalysisManager {
    let blinkDetector: BlinkDetector
    let yawnDetector: YawnDetector
    let presenceTimer: FaceAbsenceTimer

    private(set) var lastBlinkCount: Int = 0
    private(set) var lastYawnCount: Int = 0
    private(set) var lastAbsenceTime: TimeInterval = 0

    init(blinkDetector: BlinkDetector, yawnDetector: YawnDetector, presenceTimer: FaceAbsenceTimer) {
        self.blinkDetector = blinkDetector
        self.yawnDetector = yawnDetector
        self.presenceTimer = presenceTimer
    }

    convenience init() {
        self.init(
            blinkDetector: VisionBlinkDetector(),
            yawnDetector: VisionYawnDetector(),
            presenceTimer: FaceAbsenceTimer()
        )
    }

    func analyze(pixelBuffer: CVPixelBuffer) async {
        let faceObservation = try? await performFaceLandmarksDetection(on: pixelBuffer)
        let landmarks = faceObservation?.landmarks

        let isFacePresent = (faceObservation != nil)
        presenceTimer.update(isFacePresent: isFacePresent)

        lastBlinkCount = blinkDetector.detect(from: landmarks)
        lastYawnCount = yawnDetector.detect(from: landmarks)
        lastAbsenceTime = presenceTimer.totalAbsenceTime
    }
    
    func reset() {
        print("1분간 눈깜빡임: \(lastBlinkCount), 하품: \(lastYawnCount), 자리비움(초): \(Int(lastAbsenceTime))")
        blinkDetector.reset()
        yawnDetector.reset()
        presenceTimer.reset()
        lastBlinkCount = 0
        lastYawnCount = 0
        lastAbsenceTime = 0
    }

    private func performFaceLandmarksDetection(on pixelBuffer: CVPixelBuffer) async throws -> VNFaceObservation {
        try await withCheckedThrowingContinuation { continuation in
            let request = VNDetectFaceLandmarksRequest()
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            do {
                try handler.perform([request])
                if let faces = request.results, let face = faces.first {
                    continuation.resume(returning: face)
                } else {
                    continuation.resume(
                        throwing: NSError(domain: "AnalysisManager",
                                          code: 1,
                                          userInfo: [NSLocalizedDescriptionKey: "No face detected"]
                                         )
                    )
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
