//
//  TimerViewModel.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/27/25.
//

// TimerViewModel.swift

import AVFoundation

enum TimerViewState: Equatable {
    case isReady
    case isRunning
    case isCompleted
}

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var formattedTime: String = "30:00"
    @Published var backgroundDuration: Double = 30.0
    @Published var currentFocusLevel: FocusLevel = .lv4
    @Published var sessionState: TimerViewState? = nil

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

        bindCameraFrameHandler()
        bindTimerSync()
    }

    func startSession() {
        guard sessionState != .isRunning else { return }
        sessionState = .isRunning

        readySession()
        startTimers()
    }

    func stopSession() {
        guard sessionState == .isRunning else { return }
        sessionState = .isReady
        stopAll()
    }

    // MARK: - Session Preparation

    private func readySession() {
        analysisManager.readyForSession()
        cameraManager.start()
        startAnalysisTimer()
    }

    // MARK: - Timer Control

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

    // MARK: - Bindings

    private func bindTimerSync() {
        actualTimer.onTick = { [weak self] _ in
            Task { @MainActor in
                self?.updateFormattedTime()
            }
        }
        actualTimer.onFinish = { [weak self] in
            Task { @MainActor in
                self?.handleTimerFinished()
            }
        }
    }

    private func bindCameraFrameHandler() {
        cameraManager.onFrame = { [weak self] pixelBuffer in
            guard let self, !self.isProcessingFrame else { return }
            self.isProcessingFrame = true
            Task { @MainActor in
                defer { self.isProcessingFrame = false }
                self.latestPixelBuffer = pixelBuffer
                await self.handleFrameAnalysis(pixelBuffer)
            }
        }
    }

    // MARK: - Analysis Timer

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

    // MARK: - State Update

    private func updateFormattedTime() {
        formattedTime = Self.formatTime(actualTimer.lastingTime)
    }

    private static func formatTime(_ seconds: Int) -> String {
        let remaining = max(seconds, 0)
        return String(format: "%02d : %02d", remaining / 60, remaining % 60)
    }

    private func updateFocusLevel(_ newLevel: FocusLevel) {
        currentFocusLevel = newLevel
        backgroundDuration = newLevel.backgroundDuration()
        virtualTimer.updateInterval(to: newLevel.tickSpeed())
        print("🎯 집중도 업데이트: \(newLevel) -> 배경: \(backgroundDuration)초, 가상속도: \(newLevel.tickSpeed())")
    }

    // MARK: - Timer Finish

    func handleTimerFinished() {
        printFinalResult()
        stopAll()
        sessionState = .isCompleted
    }

    private func printFinalResult() {
        print("🎯 타이머 완료 - 최종 결과:")
        print("📊 실제 경과 시간: \(actualTimer.count)초")
        print("⚡ 가상 축적 시간: \(virtualTimer.count)초")
        print("🧠 최근 집중력 스코어: \(currentFocusLevel)")
    }

    // MARK: - Analysis

    private func handleFrameAnalysis(_ pixelBuffer: CVPixelBuffer) async {
        await analysisManager.analyze(pixelBuffer: pixelBuffer)
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
    
    func clear(){
        stopSession()
    }
}
