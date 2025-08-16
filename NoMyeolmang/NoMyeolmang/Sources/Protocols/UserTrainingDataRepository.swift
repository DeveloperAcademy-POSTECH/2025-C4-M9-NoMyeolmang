//
//  UserTrainingDataRepository.swift
//  NoMyeolmang
//
//  Created by Moo on 7/24/25.
//

protocol UserTrainingDataRepository {
    func write(input data: [UserTrainingData]) async throws -> Bool
    func fetch(count: Int) async throws -> [UserTrainingData]
    func update(to newScore: Double, count: Int) async throws -> Bool
    func clear() async throws -> Bool
}
