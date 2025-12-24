//
//  TrainingDataConverter.swift
//  NoMyeolmang
//
//  Created by Moo on 12/5/25.
//

import CoreML

/// # ``timé/TrainingDataConverter``
///
/// 사용자 학습 데이터를 CoreML 학습에 필요한 형식으로 변환합니다.
///
/// `TrainingDataConverter`는 ``UserTrainingData`` 배열을 ``MLArrayBatchProvider``로 변환하는
/// 유틸리티입니다. ``Features`` 데이터를 정규화하고 ``MLMultiArray``로 변환하며,
/// 학습에 필요한 입력과 라벨을 생성합니다.
///
/// > Note: 변환 실패한 샘플은 자동으로 스킵되며, 유효한 샘플만 배치에 포함됩니다.
enum TrainingDataConverter {
    /// 사용자 학습 데이터 배열을 CoreML 배치 제공자로 변환합니다.
    static func makeBatchProvider(from userTrainingDataList: [UserTrainingData]) -> MLArrayBatchProvider {
        let featureProviders = userTrainingDataList.compactMap { data -> MLFeatureProvider? in
            guard let inputArray = makeModelInputArray(features: data.features),
                  let labelArray = makeLabelArray(score: data.userScore) else { return nil }
                  
            let inputValue = MLFeatureValue(multiArray: inputArray)
            let labelValue = MLFeatureValue(multiArray: labelArray)
            
            let dict: [String: MLFeatureValue] = [
                Configuration.inputName: inputValue,
                Configuration.updatableOutputName: labelValue,
            ]
            return try? MLDictionaryFeatureProvider(dictionary: dict)
        }
        return MLArrayBatchProvider(array: featureProviders)
    }
    
    /// Features를 정규화하여 MLMultiArray로 변환합니다.
    static func makeModelInputArray(features: Features) -> MLMultiArray? {
        let scaledValues = MinMaxScaler.scale(features)
        guard let inputArray = try? MLMultiArray(shape: [1, 6], dataType: .float32) else { return nil }
        for (index, value) in scaledValues.enumerated() {
            inputArray[index] = NSNumber(value: value)
        }
        return inputArray
    }
    
    /// 사용자 점수를 MLMultiArray로 변환합니다.
    private static func makeLabelArray(score: Double) -> MLMultiArray? {
        guard let labelArray = try? MLMultiArray(shape: [1], dataType: .float32) else { return nil }
        labelArray[0] = NSNumber(value: score)
        return labelArray
    }
}
