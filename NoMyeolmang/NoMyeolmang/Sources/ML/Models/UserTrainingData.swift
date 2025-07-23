//
//  UserTrainingData.swift
//  NoMyeolmang
//
//  Created by Muchan Kim on 7/23/25.
//

import Foundation
import SwiftData

@Model
final class UserTrainingData {
    var features: [Features]
    var predictedScore: Double
    var userScore: Double
    var createdAt: Date

    init(
        features: [Features],
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
