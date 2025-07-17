//
//  FocusScorePredictor.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//

import CoreML

final class FocusScorePredictor {
    private let model: FocusScore_Updatable

    init?() {
        guard let model = try? FocusScore_Updatable(configuration: MLModelConfiguration()) else { return nil }
        self.model = model
        
        print(model.model.modelDescription.isUpdatable)
    }
    
    func run(input: MLModelInput) -> Double? {
        guard let inputArray = makeModelInputArray(input: input) else { return nil }
        return predict(inputArray: inputArray)
    }
    
    private func makeModelInputArray(input: MLModelInput) -> MLMultiArray? {
        guard let inputArray = try? MLMultiArray(shape: [1, 4], dataType: .float32) else {
            return nil
        }
        
        inputArray[0] = NSNumber(value: MinMaxScaler.scaleBlink(input.blinkCountPerMin))
        inputArray[1] = NSNumber(value: MinMaxScaler.scaleFace(input.faceBodyPresent))
        inputArray[2] = NSNumber(value: MinMaxScaler.scalePhone(input.phonePresent))
        inputArray[3] = NSNumber(value: MinMaxScaler.scaleTime(input.elapsedTime))
        return inputArray
    }

    private func predict(inputArray: MLMultiArray) -> Double? {
        guard let result = try? model.prediction(dense_1_input: inputArray) else { return nil }
        return result.Identity[0].doubleValue
    }
}
