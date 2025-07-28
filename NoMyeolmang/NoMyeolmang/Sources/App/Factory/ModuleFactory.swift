//
//  ModuleFactory.swift
//  NoMyeolmang
//
//  Created by Moo on 7/28/25.
//

import SwiftData
import SwiftUI

@MainActor
protocol ModuleFactoryProtocol {
    func makeTimerSettingView() -> TimerSettingView
    func makeTimerView() -> TimerView
    func makeFeedbackView() -> FeedbackView
    func makeReportView() -> ReportView
    func makeOnboardingView(showOnboarding: Binding<Bool>) -> OnboardingView
}

@MainActor
final class ModuleFactory: ModuleFactoryProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
        
    private lazy var userTrainingDataRepository: UserTrainingDataRepository = {
        SwiftDataUserTrainingDataRepository(context: modelContext)
    }()
    
    private lazy var focusScorePredictor: Predictor = {
        guard let model = ModelLoader.loadModel() else {
            fatalError("Failed to load ML model")
        }
    return FocusScorePredictor(model: model)
    }()
    
    private lazy var focusPersonalizater: Personalizater = {
        FocusPersonalizater(modelURL: ModelLoader.loadModelURL())
    }()
    
    private lazy var cameraManager = CameraManager()
    private lazy var analysisManager = AnalysisManager()
        
    func makeTimerSettingView() -> TimerSettingView {
        let viewModel = TimerSettingViewModel()
        return TimerSettingView(viewModel: viewModel)
    }
    
    func makeTimerView() -> TimerView {
        let viewModel = TimerViewModel(
            predictor: focusScorePredictor,
            repository: userTrainingDataRepository,
            cameraManager: cameraManager,
            analysisManager: analysisManager
        )
        return TimerView(viewModel: viewModel)
    }
    
    func makeFeedbackView() -> FeedbackView {
        let viewModel = FeedbackViewModel(
            repository: userTrainingDataRepository,
            personalizater: focusPersonalizater
        )
        return FeedbackView(viewModel: viewModel)
    }
    
    func makeReportView() -> ReportView {
        let viewModel = ReportViewModel()
        return ReportView(viewModel: viewModel)
    }
    
    func makeOnboardingView(showOnboarding: Binding<Bool>) -> OnboardingView {
        return OnboardingView(showOnboarding: showOnboarding)
    }
}
