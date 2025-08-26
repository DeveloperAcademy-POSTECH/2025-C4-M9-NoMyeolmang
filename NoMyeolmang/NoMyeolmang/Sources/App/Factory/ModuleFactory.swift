//
//  ModuleFactory.swift
//  NoMyeolmang
//
//  Created by Moo on 7/28/25.
//

import SwiftData
import SwiftUI

/// # ``timé/ModuleFactoryProtocol``
///
/// 애플리케이션의 모든 뷰와 팝오버를 생성하는 팩토리 프로토콜입니다.
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

/// # ``timé/ModuleFactory``
///
/// 의존성 주입을 통해 애플리케이션의 모든 뷰와 뷰모델을 생성하는 팩토리 클래스입니다.
///
/// ## Overview
///
/// `ModuleFactory`는 SwiftData `ModelContext`를 받아 필요한 모든 의존성을 초기화하고 관리합니다.
/// 
/// ML 모델(``FocusScorePredictor``, ``FocusPersonalizater``), 데이터 저장소(``SwiftDataUserTrainingDataRepository``),
/// 카메라 및 분석 매니저(``CameraManager``, ``AnalysisManager``)를 lazy 프로퍼티로 생성하여 
/// 각 뷰모델에 주입합니다.
///
/// > Important: 모든 의존성은 lazy 프로퍼티로 선언되어 필요할 때만 생성되며, @MainActor로 스레드 안전성을 보장합니다.
///
/// ## Topics
///
/// ### Creating Main Views
///
/// - ``makeTimerSettingView()``
/// - ``makeTimerView()``
/// - ``makeFeedbackView()``
/// - ``makeReportView()``
/// - ``makeOnboardingView(showOnboarding:)``
///
/// ### Creating Popover Views
///
/// - ``makeSettingPopoverView()``
/// - ``makeTimerPopoverView()``
/// - ``makeFeedbackPopoverView()``
/// - ``makeReportPopoverView()``
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
        
    /// 타이머 설정 화면을 생성합니다.
    func makeTimerSettingView() -> TimerSettingView {
        return TimerSettingView(viewModel: timerSettingViewModel)
    }
    
    /// 메인 타이머 화면을 생성합니다.
    func makeTimerView() -> TimerView {
        return TimerView(viewModel: timerViewModel)
    }
    
    /// 피드백 입력 화면을 생성합니다.
    func makeFeedbackView() -> FeedbackView {
        return FeedbackView(viewModel: feedbackViewModel)
    }
    
    /// 세션 리포트 화면을 생성합니다.
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
