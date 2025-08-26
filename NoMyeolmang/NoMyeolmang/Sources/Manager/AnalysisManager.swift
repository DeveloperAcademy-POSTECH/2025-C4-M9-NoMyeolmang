//
//  AnalysisManager.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/25/25.
//

import Vision
/// # ``timé/AnalysisManager``
///
/// Vision 기반 얼굴 분석을 통합하여 사용자 행동 특성을 추출하고 ML 입력 데이터를 생성합니다.
///
/// `AnalysisManager`는 ``CameraManager``에서 전달받은 비디오 프레임에 대해 `VNDetectFaceLandmarksRequest`를 수행하여
/// 얼굴 랜드마크를 감지합니다. 감지된 랜드마크는 ``VisionBlinkDetector``, ``VisionYawnDetector``, ``FaceAbsenceTimer``에
/// 전달되어 각각 눈 깜빡임, 하품, 얼굴 부재를 분석합니다.
///
/// 분석 결과는 ``generateFeatures()`` 메서드를 통해 ``Features`` 객체로 구조화되어 ``FocusScorePredictor``의
/// 입력으로 사용됩니다. 각 세션마다 ``readyForSession()``을 통해 상태를 초기화하여 정확한 분석을 보장합니다.
///
/// ### Performing Analysis
///
/// - ``analyze(pixelBuffer:)``
/// - ``generateFeatures()``
///
/// ### Managing Session State
///
/// - ``readyForSession()``
/// - ``resetState()``
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
