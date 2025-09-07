//
//  UserTrainingData.swift
//  NoMyeolmang
//
//  Updated by Moo on 9/07/25.
//

import Foundation
import SwiftData

/// # ``timé/UserTrainingData``
///
/// 머신러닝 모델의 개인화 학습을 위한 사용자 피드백 데이터를 저장합니다.
///
/// `UserTrainingData`는 ``FocusPersonalizater/run(from:)`` 메서드의 입력으로 사용되어 
/// 모델 개인화 학습을 수행합니다. Sendable 프로토콜을 준수하여 동시성 환경에서 
/// 안전하게 사용할 수 있으며, ``features`` 속성의 ``Features`` 데이터와 함께 ``predictedScore``(모델 예측값)와 
/// ``userScore``(실제 사용자 평가)를 비교하여 학습에 활용됩니다.
///
/// ### Creating Training Data
///
/// - ``init(features:predictedScore:userScore:createdAt:)``
///
/// ### Inspecting Training Data
///
/// - ``features``
/// - ``predictedScore``
/// - ``userScore``
/// - ``createdAt``

struct UserTrainingData: Sendable {
    let features: Features
    let predictedScore: Double
    let userScore: Double
    let createdAt: Date
}

@Model
final class UserTrainingDataModel {
    var features: Features
    var predictedScore: Double
    var userScore: Double
    var createdAt: Date

    init(
        features: Features,
        predictedScore: Double,
        userScore: Double,
        createdAt: Date = Date()
    ) {
        self.features = features
        self.predictedScore = predictedScore
        self.userScore = userScore
        self.createdAt = createdAt
    }
}

extension UserTrainingData {
    func toModel() -> UserTrainingDataModel {
        UserTrainingDataModel(
            features: features,
            predictedScore: predictedScore,
            userScore: userScore,
            createdAt: createdAt
        )
    }
}

extension UserTrainingDataModel {
    func toSendable() -> UserTrainingData {
        UserTrainingData(
            features: features,
            predictedScore: predictedScore,
            userScore: userScore,
            createdAt: createdAt
        )
    }
}
