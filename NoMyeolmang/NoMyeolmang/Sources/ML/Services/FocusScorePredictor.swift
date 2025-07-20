//
//  FocusScorePredictor.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//

import CoreML
import Foundation

final class FocusScorePredictor {
    var model: FocusScore_Updatable
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
        guard
            let inputArray = try? MLMultiArray(
                shape: [1, 4],
                dataType: .float32
            )
        else {
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
        return inputArray
    }

    private func predict(inputArray: MLMultiArray) -> Double? {
        guard let result = try? model.prediction(dense_1_input: inputArray)
        else { return nil }
        print("예측값: \(result.Identity[0])")
        print(self.model.model.modelDescription)
        return result.Identity[0].doubleValue
    }
}
