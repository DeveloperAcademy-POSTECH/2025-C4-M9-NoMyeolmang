//
//  UserTrainingData.swift
//  NoMyeolmang
//
//  Updated by Moo on 7/25/25.
//

import Foundation
import SwiftData

@Model
final class UserTrainingData: Sendable {
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
