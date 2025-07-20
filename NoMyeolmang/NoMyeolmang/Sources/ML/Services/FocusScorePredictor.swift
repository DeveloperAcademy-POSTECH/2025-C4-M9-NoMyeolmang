//
//  FocusScorePredictor.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/20/25.
//

import CoreML
import Foundation

final class FocusScorePredictor {
	private let model: MLModel
	var modelURL: URL

    init?() {
        self.modelURL = loadModelURL()
        if let loadedModel = loadModel(url: self.modelURL){
            self.model = loadedModel
        } else {
            return nil
        }
        print(model.model.modelDescription.isUpdatable)
    }

    func run(input: MLModelInput) -> Double? {

        guard let inputArray = makeModelInputArray(input: input) else {
            return nil
        }
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
