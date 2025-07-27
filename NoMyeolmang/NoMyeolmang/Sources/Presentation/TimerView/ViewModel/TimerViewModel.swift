//
//  TimerViewModel.swift
//  NoMyeolmang
//
//  Created by Moo on 7/26/25.
//

import AVFoundation

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var formattedTime: String = "30:00"
    @Published var backgroundDuration: Double = 30.0
    @Published var currentFocusLevel: FocusLevel = .lv4
    @Published var isRunning: Bool = false

    private let cameraManager: CameraManager
    private let analysisManager: AnalysisManager
    private let predictor: Predictor
    private let repository: UserTrainingDataRepository

    private let actualTimer = ActualTimerManager.shared
    private let virtualTimer = VirtualTimerManager.shared

    private var analysisTimer: Timer?
    private var latestPixelBuffer: CVPixelBuffer?
    private var isProcessingFrame = false

    init(
        predictor: Predictor,
        repository: UserTrainingDataRepository,
        cameraManager: CameraManager = CameraManager(),
        analysisManager: AnalysisManager = AnalysisManager()
    ) {
        self.cameraManager = cameraManager
        self.analysisManager = analysisManager
        self.predictor = predictor
        self.repository = repository

        configureCameraFrameHandler()
        configureTimerSync()
    }

    func startSession() {
        guard !isRunning else { return }
        isRunning = true

        prepareSession()
        startTimers()
    }

    func stopSession() {
        isRunning = false
        stopAll()
    }

    private func prepareSession() {
        analysisManager.readyForSession()
        cameraManager.start()
        startAnalysisTimer()
    }

    private func startTimers() {
        actualTimer.start()
        updateFormattedTime()
        virtualTimer.start()
        virtualTimer.updateInterval(to: currentFocusLevel.tickSpeed())
    }

    private func stopAll() {
        cameraManager.stop()
        stopAnalysisTimer()
        actualTimer.stop()
        virtualTimer.stop()
    }

    private func configureTimerSync() {
        actualTimer.onTick = { [weak self] _ in
            Task { @MainActor in
                self?.updateFormattedTime()
            }
        }
        actualTimer.onFinish = { [weak self] in
            Task { @MainActor in
                self?.onTimerFinished()
            }
        }
    }

    private func configureCameraFrameHandler() {
        cameraManager.onFrame = { [weak self] pixelBuffer in
            guard let self, !self.isProcessingFrame else { return }
            self.isProcessingFrame = true
            Task { @MainActor in
                defer { self.isProcessingFrame = false }
                self.latestPixelBuffer = pixelBuffer
                await self.analysisManager.analyze(pixelBuffer: pixelBuffer)
            }
        }
    }

    private func startAnalysisTimer() {
        analysisTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                await self.handleAnalysisTimerTick()
            }
        }
    }

    private func stopAnalysisTimer() {
        analysisTimer?.invalidate()
        analysisTimer = nil
    }

    private func updateFormattedTime() {
        let remaining = max(actualTimer.lastingTime, 0)
        formattedTime = String(format: "%02d:%02d", remaining / 60, remaining % 60)
    }

    private func onTimerFinished() {
        stopSession()
        printFinalResult()
    }

    private func printFinalResult() {
        print("🎯 타이머 완료 - 최종 결과:")
        print("📊 실제 경과 시간: \(actualTimer.count)초")
        print("⚡ 가상 축적 시간: \(virtualTimer.count)초")
        print("🧠 최종 집중도: \(currentFocusLevel)")
    }

    private func updateFocusLevel(_ newLevel: FocusLevel) {
        currentFocusLevel = newLevel
        backgroundDuration = newLevel.backgroundDuration()
        virtualTimer.updateInterval(to: newLevel.tickSpeed())
        print("🎯 집중도 업데이트: \(newLevel) -> 배경: \(backgroundDuration)초, 가상속도: \(newLevel.tickSpeed())")
    }

    private func handleAnalysisTimerTick() async {
        guard latestPixelBuffer != nil else { return }
        let features = analysisManager.generateFeatures()
        let userTrainingData = predictor.run(from: features)

        if let newLevel = FocusLevel.from(rawValue: userTrainingData.predictedScore) {
            updateFocusLevel(newLevel)
        }

        do {
            let success = try await repository.write(input: [userTrainingData])
            if success {
                print("Feature: ", userTrainingData.features)
                print("Score: ", userTrainingData.predictedScore)
                print("Time: ", userTrainingData.createdAt)
            }
        } catch {
            print("저장 오류: \(error.localizedDescription)")
        }
        analysisManager.resetState()
    }
}
