//
//  MainViewModel.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//

import Foundation

final class MainViewModel: ObservableObject {
    @Published var blinkCount: String = "0"
    @Published var faceBodyPresent: String = "0.0"
    @Published var phonePresent: String = "0.0"
    @Published var elapsedTime: String = "0.0"
    @Published var userScore: Int = 3
    @Published var predictionResult: Double?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    private let predictor: FocusScorePredictor

    init() {
        guard let predictor = FocusScorePredictor() else {
            fatalError("FocusScorePredictor 인스턴스 생성 실패")
        }
        self.predictor = predictor
    }
    
    func predict() {
        guard let input = makeModelInput() else {
            handlePredictionFailure()
            return
        }
        
        if let result = predictor.run(input: input) {
            handlePredictionSuccess(result: result)
        } else {
            handlePredictionFailure()
        }
    }
    
    private func makeModelInput() -> MLModelInput? {
        // 각 값의 입력 범위(실제 서비스에서는 필요없음)
        guard let blinkCount = Double(blinkCount),
              let faceBodyPresent = Double(faceBodyPresent),
              let phonePresent = Double(phonePresent),
              let elapsedTime = Double(elapsedTime),
              blinkCount >= 3.0 && blinkCount <= 20.0,
              faceBodyPresent >= 0.0 && faceBodyPresent <= 1.0,
              phonePresent >= 0.0 && phonePresent <= 1.0,
              elapsedTime >= 1.0 && elapsedTime <= 30.0 else {
            return nil
        }
        
        return MLModelInput(
            blinkCountPerMin: blinkCount,
            faceBodyPresent: faceBodyPresent,
            phonePresent: phonePresent,
            elapsedTime: elapsedTime
        )
    }
    
    private func handlePredictionSuccess(result: Double) {
        predictionResult = result
        errorMessage = nil
        showAlert = false
    }
    
    private func handlePredictionFailure() {
        predictionResult = nil
        errorMessage = "입력값을 확인하세요.\n(눈 깜빡임: 3~20, 얼굴/신체: 0.0~1.0, 핸드폰: 0.0~1.0, 경과 시간: 1~30)"
        showAlert = true
    }
}
