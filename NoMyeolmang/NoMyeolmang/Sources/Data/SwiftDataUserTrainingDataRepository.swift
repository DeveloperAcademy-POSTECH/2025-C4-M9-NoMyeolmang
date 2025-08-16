//  SwiftDataUserTrainingDataRepository.swift
//  NoMyeolmang
//
//  Created by Moo on 7/24/25.
//

import Foundation
import SwiftData

final class SwiftDataUserTrainingDataRepository: UserTrainingDataRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func write(input data: [UserTrainingData]) async throws -> Bool {
        data.forEach { context.insert($0) }
        do {
            try context.save()
            return true
        } catch {
            print("Write error: \(error)")
            throw error
        }
    }

    func fetch(count: Int) async throws -> [UserTrainingData] {
        let descriptor = makeFetchDescriptor(fetchLimit: count)
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Fetch error: \(error)")
            throw error
        }
    }
    
    func update(to newScore: Double, count: Int) async throws -> Bool {
        let descriptor = makeFetchDescriptor(fetchLimit: count)
        do {
            let results = try context.fetch(descriptor)
            results.forEach { $0.userScore = newScore }
            try context.save()
            return true
        } catch {
            print("Update error: \(error)")
            throw error
        }
    }
    
    func clear() async throws -> Bool {
        let descriptor = makeFetchDescriptor()
        do {
            let allData = try context.fetch(descriptor)
            allData.forEach { context.delete($0) }
            try context.save()
            return true
        } catch {
            print("Clear error: \(error)")
            throw error
        }
    }
    
    private func makeFetchDescriptor(
        predicate: Predicate<UserTrainingData>? = nil,
        sortBy: [SortDescriptor<UserTrainingData>] = [SortDescriptor(\.createdAt, order: .reverse)],
        fetchLimit: Int? = nil
    ) -> FetchDescriptor<UserTrainingData> {
        var descriptor = FetchDescriptor<UserTrainingData>(
            predicate: predicate,
            sortBy: sortBy
        )
        if let fetchLimit = fetchLimit {
            descriptor.fetchLimit = fetchLimit
        }
        return descriptor
    }
}
