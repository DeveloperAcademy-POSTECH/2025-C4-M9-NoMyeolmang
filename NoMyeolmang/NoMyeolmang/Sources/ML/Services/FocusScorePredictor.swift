//
//  FocusScorePredictor.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/23/25.
//

import CoreML

final class FocusScorePredictor: Predictor {
    private let model: MLModel

    init(model: MLModel) {
        self.model = model
    }

    func run(from features: Features) -> UserTrainingData {
        let predictedScore = predict(features: features) ?? 0.0
        return UserTrainingData(features: [features], predictedScore: predictedScore, userScore: 0.0)
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
