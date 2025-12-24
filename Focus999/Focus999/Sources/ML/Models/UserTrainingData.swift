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
/// ML 서비스용 Sendable 구조체입니다.
///
/// ``FocusPersonalizater/run(from:)`` 메서드의 입력으로 사용되어 모델 개인화 학습을 수행합니다.
/// Swift 6 동시성 안전성을 위해 ``UserTrainingDataModel`` (SwiftData 저장용)과 분리되었습니다.
///
/// > Note: Repository에서 자동으로 ``UserTrainingDataModel``로 변환하여 저장합니다.

struct UserTrainingData: Sendable {
    let features: Features
    let predictedScore: Double
    let userScore: Double
    let createdAt: Date
}

/// SwiftData 저장용 @Model 클래스입니다.
///
/// ``UserTrainingData``와 동일한 데이터를 포함하지만 SwiftData 요구사항에 맞춰 mutable 프로퍼티를 가집니다.
/// Repository 내부에서만 사용합니다.
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

// MARK: - Model Conversion Extensions

extension UserTrainingData {
    /// SwiftData 저장을 위해 UserTrainingDataModel로 변환합니다.
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
    /// Sendable UserTrainingData 구조체로 변환합니다.
    func toSendable() -> UserTrainingData {
        UserTrainingData(
            features: features,
            predictedScore: predictedScore,
            userScore: userScore,
            createdAt: createdAt
        )
    }
}
