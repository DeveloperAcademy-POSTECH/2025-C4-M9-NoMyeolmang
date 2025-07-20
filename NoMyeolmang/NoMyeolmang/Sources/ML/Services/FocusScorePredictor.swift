//
//  FocusScorePredictor.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/20/25.
//

import CoreML

final class FocusScorePredictor {
    private let model: MLModel

    init?(modelURL: URL) {
        guard let model = try? MLModel(contentsOf: modelURL) else { return nil }
        self.model = model
    }

    convenience init?() {
        guard let bundleURL = Bundle.main.url(forResource: "FocusScore_Updatable", withExtension: "mlmodelc") else { return nil }
        self.init(modelURL: bundleURL)
    }

    func run(input: MLModelInput) -> Double? {
        guard let inputArray = makeModelInputArray(input: input) else { return nil }
        return predict(inputArray: inputArray)
    }

    private func makeModelInputArray(input: MLModelInput) -> MLMultiArray? {
        guard let inputArray = try? MLMultiArray(shape: [1, 4], dataType: .float32) else { return nil }
        
        inputArray[0] = NSNumber(value: MinMaxScaler.scaleBlink(input.blinkCountPerMin))
        inputArray[1] = NSNumber(value: MinMaxScaler.scaleFace(input.faceBodyPresent))
        inputArray[2] = NSNumber(value: MinMaxScaler.scalePhone(input.phonePresent))
        inputArray[3] = NSNumber(value: MinMaxScaler.scaleTime(input.elapsedTime))
        return inputArray
    }

    private func predict(inputArray: MLMultiArray) -> Double? {
        guard let inputFeatures = try? MLDictionaryFeatureProvider(dictionary: ["dense_1_input": inputArray]),
              let result = try? model.prediction(from: inputFeatures),
              let outputArray = result.featureValue(for: "Identity")?.multiArrayValue else { return nil }
        return outputArray[0].doubleValue
    }
}
