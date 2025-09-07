//  SwiftDataUserTrainingDataRepository.swift
//  NoMyeolmang
//
//  Created by Moo on 7/24/25.
//

import Foundation
import SwiftData

/// # ``timé/SwiftDataUserTrainingDataRepository``
///
/// SwiftData를 사용하여 사용자 행동 패턴 데이터의 CRUD 작업을 수행합니다.
///
/// ## Overview
///
/// `SwiftDataUserTrainingDataRepository`는 ``UserTrainingDataRepository`` 프로토콜을 구현하여
/// ``UserTrainingData`` 객체들에 대한 생성, 조회, 업데이트, 삭제 작업을 제공합니다.
/// 저장된 행동 패턴 데이터는 ``FocusPersonalizater``에서 모델 개인화 학습에 활용됩니다.
///
/// > Note: 모든 데이터베이스 작업은 비동기적으로 수행되며, 에러 발생 시 적절한 예외를 throw합니다.
///
/// ## Topics
///
/// ### Data Operations
///
/// - ``write(input:)``
/// - ``fetch(count:)``
/// - ``update(to:count:)``
/// - ``clear()``
final class SwiftDataUserTrainingDataRepository: UserTrainingDataRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func write(input data: [UserTrainingData]) async throws -> Bool {
        let models = data.map { $0.toModel() }
        models.forEach { context.insert($0) }
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
            let models = try context.fetch(descriptor)
            return models.map { $0.toSendable() }
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
        predicate: Predicate<UserTrainingDataModel>? = nil,
        sortBy: [SortDescriptor<UserTrainingDataModel>] = [SortDescriptor(\.createdAt, order: .reverse)],
        fetchLimit: Int? = nil
    ) -> FetchDescriptor<UserTrainingDataModel> {
        var descriptor = FetchDescriptor<UserTrainingDataModel>(
            predicate: predicate,
            sortBy: sortBy
        )
        if let fetchLimit = fetchLimit {
            descriptor.fetchLimit = fetchLimit
        }
        return descriptor
    }
}
