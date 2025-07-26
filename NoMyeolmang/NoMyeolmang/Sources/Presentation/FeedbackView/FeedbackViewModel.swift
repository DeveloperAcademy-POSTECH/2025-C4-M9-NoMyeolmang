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

    /// Test Code
    func writeTestData() async {
        print("💾 === WRITE 테스트 시작 ===")

        // 테스트 UserTrainingData 생성
        let testData = createTestData()
        print("📝 생성된 UserTrainingData: \(testData.count)개")

        do {
            print("\n💾 repository.write() 실행중...")
            let writeSuccess = try await repository.write(input: testData)

            if writeSuccess {
                print("✅ write() 성공! \(testData.count)개 UserTrainingData 저장완료")
                print("🔍 이제 '데이터 조회' 버튼으로 저장된 데이터를 확인해보세요!")
            } else {
                print("❌ write() 실패!")
            }

        } catch {
            print("❌ write() 에러: \(error.localizedDescription)")
        }

        print("💾 === WRITE 테스트 완료 ===\n")
    }

    func createTestData() -> [UserTrainingData] {
        let testCases = [
            (
                blink: 12.0, yawn: 1.0, face: 1.0, phone: 0.0, time: 5.0,
                longBlink: 2.0, predicted: 3.2
            ),
            (
                blink: 18.0, yawn: 3.0, face: 0.8, phone: 0.2, time: 15.0,
                longBlink: 4.0, predicted: 2.1
            ),
            (
                blink: 8.0, yawn: 0.0, face: 1.0, phone: 0.0, time: 10.0,
                longBlink: 1.0, predicted: 4.5
            ),
            (
                blink: 15.0, yawn: 2.0, face: 0.9, phone: 0.1, time: 20.0,
                longBlink: 3.0, predicted: 2.8
            ),
            (
                blink: 10.0, yawn: 1.0, face: 1.0, phone: 0.0, time: 8.0,
                longBlink: 1.0, predicted: 3.8
            ),
            (
                blink: 12.0, yawn: 1.0, face: 1.0, phone: 0.0, time: 5.0,
                longBlink: 2.0, predicted: 3.2
            ),
            (
                blink: 18.0, yawn: 3.0, face: 0.8, phone: 0.2, time: 15.0,
                longBlink: 4.0, predicted: 2.1
            ),
            (
                blink: 8.0, yawn: 0.0, face: 1.0, phone: 0.0, time: 10.0,
                longBlink: 1.0, predicted: 4.5
            ),
            (
                blink: 15.0, yawn: 2.0, face: 0.9, phone: 0.1, time: 20.0,
                longBlink: 3.0, predicted: 2.8
            ),
            (
                blink: 10.0, yawn: 1.0, face: 1.0, phone: 0.0, time: 8.0,
                longBlink: 1.0, predicted: 3.8
            ),
        ]

        return testCases.map { testCase in
            let features = Features(
                blinkCountPerMin: testCase.blink,
                faceBodyPresent: testCase.face,
                phonePresent: testCase.phone,
                elapsedTime: testCase.time,
                yawnPerMin: testCase.yawn,
                longBlinkPerMin: testCase.longBlink
            )

            return UserTrainingData(
                features: features,
                predictedScore: testCase.predicted,
                userScore: 0.0  // 초기값은 0, 나중에 업데이트 테스트
            )
        }
    }
    /// Test Code

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
            personalizater.run(from: recentDataList)

            
        } catch {
            print("❌ 에러: \(error.localizedDescription)")
            return false
        }
        // 성공하면 성공 print
        print("✅ 개인화 성공!")
        return true
    }

}
