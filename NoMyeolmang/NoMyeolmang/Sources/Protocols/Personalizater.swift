//
//  FocusPersonalizater.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/23/25.
//

protocol Personalizater {
    func run(from userTrainingDataList: [UserTrainingData]) async throws -> Bool
}
