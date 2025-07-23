//
//  Predictor.swift
//  NoMyeolmang
//
//  Created by Muchan Kim on 7/23/25.
//

protocol Predictor {
    func run(from features: Features) -> UserTrainingData
}
