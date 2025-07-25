//
//  AnalysisManager.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/24/25.
//

import Vision

final class AnalysisManager {
    let blinkDetector: BlinkDetector
    let yawnDetector: YawnDetector
    let presenceTimer: FaceAbsenceTimer

    private(set) var lastBlinkCount: Int = 0
    private(set) var lastYawnCount: Int = 0
    private(set) var lastAbsenceTime: TimeInterval = 0
    private(set) var elapsedTime: Int = 0

    init(
        blinkDetector: BlinkDetector,
        yawnDetector: YawnDetector,
        presenceTimer: FaceAbsenceTimer
    ) {
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
        let faceObservation = await performFaceLandmarksDetection(on: pixelBuffer)
        let landmarks = faceObservation?.landmarks

        let isFacePresent = (faceObservation != nil)
        presenceTimer.update(isFacePresent: isFacePresent)

        lastBlinkCount = blinkDetector.detect(from: landmarks)
        lastYawnCount = yawnDetector.detect(from: landmarks)
        lastAbsenceTime = presenceTimer.totalAbsenceTime
    }

    func generateFeatures() -> Features {
        elapsedTime += 1
        return Features(
            blinkCountPerMin: Double(lastBlinkCount),
            faceBodyPresent: Double(lastAbsenceTime),
            phonePresent: 0.1,
            elapsedTime: Double(elapsedTime),
            yawnPerMin: Double(lastYawnCount),
            longBlinkPerMin: 1.0
        )
    }

    func resetState() {
        blinkDetector.reset()
        yawnDetector.reset()
        presenceTimer.reset()
        lastBlinkCount = 0
        lastYawnCount = 0
        lastAbsenceTime = 0
    }

    func readyForSession() {
        elapsedTime = 0
        resetState()
    }

    private func performFaceLandmarksDetection(on pixelBuffer: CVPixelBuffer) async -> VNFaceObservation? {
        await withCheckedContinuation { continuation in
            let request = VNDetectFaceLandmarksRequest()
            let handler = VNImageRequestHandler(
                cvPixelBuffer: pixelBuffer,
                orientation: .up,
                options: [:]
            )
            do {
                try handler.perform([request])
                continuation.resume(returning: request.results?.first)
            } catch {
                continuation.resume(returning: nil)
            }
        }
    }
}
