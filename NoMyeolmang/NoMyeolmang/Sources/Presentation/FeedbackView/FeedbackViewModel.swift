//
//  FeedbackViewModel.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/26/25.
//

import SwiftData
import SwiftUI

class FeedbackViewModel: ObservableObject {
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

    @MainActor
    func updateTrainingData() async -> Bool {
        guard let selectedIndex else {
            print("정답 입력 필요")
            return false
        }

        do {
            // 업데이트 전 확인
            print("🔍 업데이트 전 데이터 상태 확인...")
            let beforeData = try await repository.fetch(count: recordCount)
            if beforeData.count < 10 {
                print("📭 업데이트할 데이터가 부족합니다.")
                return false
            }

            // repository.update() 실행
            let isUpdated = try await repository.update(
                to: Double(selectedIndex),
                count: recordCount
            )
            if isUpdated {
                print("✅ update() 성공!")
            } else {
                print("❌ update() 실패!")
            }
            return isUpdated
        } catch {
            print("❌ update() 에러: \(error.localizedDescription)")
            return false
        }
    }

    @MainActor
    func personalizing() async -> Bool {
        
        do {
            // recentData 불러오기
            let recentDataList = try await repository.fetch(count: recordCount)
            
            // recentData에 정답값이 0.0이 아닌지 확인
            let allNonZero = recentDataList.allSatisfy { $0.userScore != 0.0 }
            if !allNonZero {
                print("❌ 정답 데이터 오류")
                return false
            }
            
            // 개인화 모듈에 넘겨주기
            let isPersonalized = personalizater.run(from: recentDataList)
            return isPersonalized
            
        } catch {
            print("❌ 에러: \(error.localizedDescription)")
            return false
        }
    }
}
