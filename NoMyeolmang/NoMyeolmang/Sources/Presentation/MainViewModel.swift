//
//  MainViewModel.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//

import CoreML
import Foundation

final class MainViewModel: ObservableObject {
    @Published var blinkCount: String = "0"
    @Published var faceBodyPresent: String = "0.0"
    @Published var phonePresent: String = "0.0"
    @Published var elapsedTime: String = "0.0"
    @Published var yawnCount: String = "0"
    @Published var longBlinkCount: String = "0"
    
    @Published var userScore: Int = 3
    @Published var predictionResult: Double?
    @Published var errorMessage: String?

    private let predictor: FocusScorePredictor
    private let personalizator: FocusPersonalizater

    init() {
        guard let predictor = FocusScorePredictor() else {
            fatalError("FocusScorePredictor 인스턴스 생성 실패")
        }
        self.predictor = predictor
        self.personalizator = FocusPersonalizater()
    }

    func predict() {
        
        guard let input = makeModelInput() else {
            return
        }

        let userScore = Double(userScore)
        saveUserData(input: input, label: userScore)

        if let result = predictor.run(input: input) {
            handlePredictionSuccess(result: result)
        }
    }

    private func makeModelInput() -> MLModelInput? {
        // 각 값의 입력 범위(실제 서비스에서는 필요없음)
        guard let blinkCount = Double(blinkCount),
              let faceBodyPresent = Double(faceBodyPresent),
              let phonePresent = Double(phonePresent),
              let elapsedTime = Double(elapsedTime),
              let yawnCount = Double(yawnCount),
              let longBlinkCount = Double(longBlinkCount)
        else { return nil }
        
        return MLModelInput(
            blinkCountPerMin: blinkCount,
            faceBodyPresent: faceBodyPresent,
            phonePresent: phonePresent,
            elapsedTime: elapsedTime,
            yawnCountPerMin: yawnCount,
            longBlinkCountPerMin: longBlinkCount
        )
    }

    private func handlePredictionSuccess(result: Double) {
        predictionResult = result
    }
    
    func personalize() {
        print("(1) 개인화 함수진입")
        personalizator.run(predictor: predictor)
    }
}
