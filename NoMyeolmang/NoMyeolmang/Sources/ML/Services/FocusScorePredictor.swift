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

    init?(modelURL: URL) {
        guard let model = try? MLModel(contentsOf: modelURL) else { return nil }
        self.model = model
    }

    convenience init?() {
        guard
            let bundleURL = Bundle.main.url(
                forResource: "FocusScore_Updatable",
                withExtension: "mlmodelc"
            )
        else { return nil }
        self.init(modelURL: bundleURL)
    }

    func run(input: MLModelInput) -> Double? {
        guard let inputArray = makeModelInputArray(input: input) else {
            return nil
        }
        return predict(inputArray: inputArray)
    }

    private func makeModelInputArray(input: MLModelInput) -> MLMultiArray? {
        guard
            let inputArray = try? MLMultiArray(
                shape: [1, 6],
                dataType: .float32
            )
        else {
            print("⛔️ MultiArray 생성 실패")
            return nil
        }

        inputArray[0] = NSNumber(
            value: MinMaxScaler.scaleBlink(input.blinkCountPerMin)
        )
        inputArray[1] = NSNumber(
            value: MinMaxScaler.scaleFace(input.faceBodyPresent)
        )
        inputArray[2] = NSNumber(
            value: MinMaxScaler.scalePhone(input.phonePresent)
        )
        inputArray[3] = NSNumber(
            value: MinMaxScaler.scaleTime(input.elapsedTime)
        )
        inputArray[4] = NSNumber(
            value: MinMaxScaler.scaleYawn(input.yawnCountPerMin)
        )
        inputArray[5] = NSNumber(
            value: MinMaxScaler.scaleLongBlink(input.longBlinkCountPerMin)
        )
        return inputArray
    }

    private func predict(inputArray: MLMultiArray) -> Double? {
        guard
            let inputFeatures = try? MLDictionaryFeatureProvider(dictionary: [
                Constants.inputName: inputArray
            ])
        else {
            print("⛔️ inputFeatures 생성 실패")
            return nil
        }

        guard let result = try? model.prediction(from: inputFeatures)
        else {
            print("⛔️ prediction 실패")
            return nil
        }
        guard
            let outputArray = result.featureValue(for: Constants.outputName)?
                .multiArrayValue
        else {
            print("⛔️ outputArray 생성 실패")
            return nil
        }
        return outputArray[0].doubleValue
    }
}
