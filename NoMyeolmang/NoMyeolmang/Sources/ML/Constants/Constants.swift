//
//  Constants.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//
// from Dodin_5_with_score_cleaned.csv
import Foundation

enum Constants {
    // 눈 깜빡임 빈도(분)
    static let blinkCountPerMinValue: Double = 5.0
    static let blinkCounterPerMaxValue: Double = 20.0

    // 자리 비움 시간
    static let faceBodyPresentMinValue: Double = 0.0
    static let faceBodyPresentMaxValue: Double = 1.0

    // 휴대폰 사용 시간
    static let phonePresentMinValue: Double = 0.0
    static let phonePresentMaxValue: Double = 1.0

    // 경과 시간
    static let elapsedTimeMinValue: Double = 1.0
    static let elapsedTimeMaxValue: Double = 30.0

    // 모델 입력,출력층 이름
    static let inputName = "dense_1_input"
    static let outputName = "Identity_true"
}

struct ModelPaths {
    static let documentsDirectory = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first!

    static let tempUpdatedModelURL = documentsDirectory.appendingPathComponent(
        "TempUpdatedModel"
    )
    static let updatedModelURL = documentsDirectory.appendingPathComponent(
        "UpdatedModel"
    )
}
