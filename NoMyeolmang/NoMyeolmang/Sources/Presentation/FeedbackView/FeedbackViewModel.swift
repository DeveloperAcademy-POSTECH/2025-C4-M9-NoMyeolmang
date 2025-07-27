//
//  FeedbackViewModel.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/26/25.
//

import SwiftData
import SwiftUI

@MainActor
final class FeedbackViewModel: ObservableObject {
    private let repository: UserTrainingDataRepository
    private let personalizater: Personalizater

    @Published var hoveredIndex: Int?
    @Published var selectedIndex: Int?
    let recordCount = 10

    init(repository: UserTrainingDataRepository, personalizater: Personalizater)
    {
        self.repository = repository
        self.personalizater = personalizater
    }

    private func fetchValidRecentData() async throws -> [UserTrainingData]? {
        let data = try await repository.fetch(count: recordCount)
        if data.count < 10 {
            print("📭 업데이트할 데이터가 부족합니다.")
            return nil
        }
        
        guard data.allSatisfy({ $0.userScore != 0.0 }) else {
                print("❌ 정답 데이터 오류")
                return nil
            }
        return data
    }

    func updateTrainingDataAndPersonalize() async -> Bool {
        guard let selectedIndex else {
            print("정답 입력 필요")
            return false
        }

        do {
            // repository.update() 실행
            let isUpdated = try await repository.update(
                to: Double(selectedIndex),
                count: recordCount
            )
            if !isUpdated {
                print("❌ update() 실패!")
                return false
            }
            print("✅ update() 성공!")
            
            guard let recentDataList = try await fetchValidRecentData() else {
                return false
            }
            
            // 개인화 모듈에 넘겨주기
            let isPersonalized = personalizater.run(from: recentDataList)
            
            print("✅ 개인화 성공!")
            return isPersonalized
            
        } catch {
            print("❌ 에러: \(error.localizedDescription)")
            return false
        }
    }
}
