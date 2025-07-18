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
    @Published var userScore: Int = 3
    @Published var predictionResult: Double?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false

    private let predictor: FocusScorePredictor
    private let personalizator: FocusPersonalizator

    init() {
        guard let predictor = FocusScorePredictor() else {
            fatalError("FocusScorePredictor 인스턴스 생성 실패")
        }
        self.predictor = predictor
        self.personalizator = FocusPersonalizator()
    }

    func predict() {
        guard let input = makeModelInput() else {
            handlePredictionFailure()
            return
        }

        let userScore = Double(userScore)
        saveUserData(input: input, label: userScore)

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
            elapsedTime >= 1.0 && elapsedTime <= 30.0
        else {
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
        errorMessage =
            "입력값을 확인하세요.\n(눈 깜빡임: 3~20, 얼굴/신체: 0.0~1.0, 핸드폰: 0.0~1.0, 경과 시간: 1~30)"
        showAlert = true
    }

    func checkModelLayer() {
        do {
            let config = MLModelConfiguration()
            let modelURL = Bundle.main.url(forResource: "FocusScore_Updatable", withExtension: "mlmodelc")!
            let model = try MLModel(contentsOf: modelURL, configuration: config)

            print("📥 [입력 키 목록]")
            for input in model.modelDescription.inputDescriptionsByName {
                print("  • \(input.key): \(input.value)")
            }

            print("📤 [출력 키 목록]")
            for output in model.modelDescription.outputDescriptionsByName {
                print("  • \(output.key): \(output.value)")
            }
        } catch {
            print("⛔️ 모델 로드 또는 설명 조회 실패: \(error)")
        }
    }
    
    func personalize() {
        print("start personalization")

        // 1. 사용자 입력 리스트 불러오기
        let dataList = loadUserData()
        print("count:", dataList.count)

        // 2. input MLMultiArray, outputArray 만들기
        var inputArray: [MLMultiArray] = []
        var outputArray: [MLMultiArray] = []
        for data in dataList {
            if let result = personalizator.makeInputMultiArray(data: data.input) {
                inputArray.append(result)
            }
            if let result = personalizator.makeLabelMultiArray(data: data.label) {
                outputArray.append(result)
            }        }

        // 4. MLBatchProvider 만들기
        let batchProvider = personalizator.makeBatchProvider(
            inputArray: inputArray,
            outputArray: outputArray
        )
        print("📦 batchProvider 전체 샘플 수: \(batchProvider.count)")

        for i in 0..<batchProvider.count {
            let sample = batchProvider.features(at: i)
            print("🔹 [샘플 \(i)]")

            for feature in sample.featureNames {
                if let value = sample.featureValue(for: feature) {
                    print("    \(feature): \(value)")
                } else {
                    print("    \(feature): nil")
                }
            }
        }

        // 5. MLUpdateTask로 모델 업데이트
        personalizator.makeUpdateTask(batchProvider: batchProvider, predictor: predictor)
        print("update predictor.model")

    }
}
