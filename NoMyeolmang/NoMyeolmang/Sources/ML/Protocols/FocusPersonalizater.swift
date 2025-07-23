//
//  FocusPersonalizater.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/23/25.
//

import CoreML
import Foundation

protocol Personalizater {
    init?(model: MLModel)
    func run(from userTrainingDataList: [UserTrainingData] ) -> Bool
}

class FocusPersonalizater: Personalizater {
    required init?(model: MLModel) {
        fatalError("init(model:) has not been implemented")
    }
    
    func run(from userTrainingDataList: [UserTrainingData]) -> Bool {
        return true
    }
}
