//
//  FocusScorePredictor.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/23/25.
//

import CoreML

/// # ``timé/FocusScorePredictor``
///
/// 머신러닝 모델을 사용하여 사용자의 행동 특성으로부터 집중도 점수를 예측합니다.
///
/// `FocusScorePredictor`는 ``Features`` 객체의 행동 특성 데이터를 받아 CoreML 모델을 통해
/// 집중도 점수를 예측합니다. 입력 데이터는 ``MinMaxScaler``의 정적 메서드들을 사용하여
/// 0-1 범위로 정규화됩니다. ``run(from:)`` 메서드를 호출하면 예측된 점수와 함께
/// ``UserTrainingData`` 객체가 반환됩니다.
///
/// > Warning: 잘못된 ``Features`` 입력이나 모델 로딩 실패 시 예측이 실패할 수 있으며, 이 경우 기본값 0.0이 반환됩니다.
///
/// ### Creating a Predictor
///
/// - ``init(model:)``
///
/// ### Performing Prediction
///
/// - ``run(from:)``
final class FocusScorePredictor: Predictor {
    private let model: MLModel

    init(model: MLModel) {
        self.model = model
    }

    func run(from features: Features) -> UserTrainingData {
        let predictedScore = predict(features: features) ?? 0.0
        return UserTrainingData(features: features, predictedScore: predictedScore, userScore: 0.0)
    }

    private func makeModelInputArray(features: Features) -> MLMultiArray? {
        guard let inputArray = try? MLMultiArray(shape: [1, 6], dataType: .float32) else { return nil }

        inputArray[0] = NSNumber(value: MinMaxScaler.scaleBlink(features.blinkCountPerMin))
        inputArray[1] = NSNumber(value: MinMaxScaler.scaleFace(features.faceBodyPresent))
        inputArray[2] = NSNumber(value: MinMaxScaler.scalePhone(features.phonePresent))
        inputArray[3] = NSNumber(value: MinMaxScaler.scaleTime(features.elapsedTime))
        inputArray[4] = NSNumber(value: MinMaxScaler.scaleYawn(features.yawnPerMin))
        inputArray[5] = NSNumber(value: MinMaxScaler.scaleLongBlink(features.longBlinkPerMin))
        return inputArray
    }

    private func predict(features: Features) -> Double? {
        guard let inputArray = makeModelInputArray(features: features) else { return nil }
        guard let inputFeatures = try? MLDictionaryFeatureProvider(dictionary: ["dense_4_input": inputArray]),
              let result = try? model.prediction(from: inputFeatures),
              let outputArray = result.featureValue(for: "Identity")?.multiArrayValue else { return nil }
        return outputArray[0].doubleValue
    }
}
