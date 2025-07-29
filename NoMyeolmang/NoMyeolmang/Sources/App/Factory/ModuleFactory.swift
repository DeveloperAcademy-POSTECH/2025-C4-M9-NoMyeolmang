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
    
    func makeSettingPopoverView() -> SettingPopoverView
    func makeTimerPopoverView() -> TimerPopoverView
    func makeFeedbackPopoverView() -> FeedbackPopoverView
    func makeReportPopoverView() -> ReportPopoverView
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
    
    private lazy var timerSettingViewModel = TimerSettingViewModel()
    private lazy var timerViewModel = TimerViewModel(predictor: focusScorePredictor,repository: userTrainingDataRepository)
    private lazy var feedbackViewModel = FeedbackViewModel(repository: userTrainingDataRepository, personalizater: focusPersonalizater)
    private lazy var reportViewModel = ReportViewModel()
        
    func makeTimerSettingView() -> TimerSettingView {
        return TimerSettingView(viewModel: timerSettingViewModel)
    }
    
    func makeTimerView() -> TimerView {
        return TimerView(viewModel: timerViewModel)
    }
    
    func makeFeedbackView() -> FeedbackView {
        return FeedbackView(viewModel: feedbackViewModel)
    }
    
    func makeReportView() -> ReportView {
        return ReportView(viewModel: reportViewModel)
    }
    
    func makeOnboardingView(showOnboarding: Binding<Bool>) -> OnboardingView {
        return OnboardingView(showOnboarding: showOnboarding)
    }
    
    func makeSettingPopoverView() -> SettingPopoverView {
        return SettingPopoverView(viewModel: timerSettingViewModel)
    }
    
    func makeTimerPopoverView() -> TimerPopoverView {
        return TimerPopoverView(viewModel: timerViewModel)
    }
    
    func makeFeedbackPopoverView() -> FeedbackPopoverView {
        return FeedbackPopoverView(viewModel: feedbackViewModel)
    }
    
    func makeReportPopoverView() -> ReportPopoverView {
        return ReportPopoverView(viewModel: reportViewModel)
    }
}
