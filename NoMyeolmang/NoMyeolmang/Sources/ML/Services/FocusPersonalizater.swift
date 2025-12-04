//
//  FocusPersonalizater.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/23/25.
//

import CoreML

/// # ``timé/FocusPersonalizater``
///
/// 사용자 피드백 데이터를 활용하여 머신러닝 모델을 개인화 학습시킵니다.
///
/// `FocusPersonalizater`는 ``UserTrainingData`` 배열을 받아 MLUpdateTask를 통해
/// 모델을 비동기적으로 업데이트합니다. ``run(from:)`` 메서드는 사용자의 실제 평가 점수와
/// 모델 예측값 간의 차이를 학습하여 개인화된 모델을 생성합니다. 업데이트된 모델은
/// ``Configuration/updatedModelURL``에 저장되며, ``ModelLoader``가 다음 실행 시
/// 우선적으로 로드합니다.
///
/// > Note: 모델 개인화는 비동기적으로 수행되며, 충분한 학습 데이터(최소 10개 이상)가 있을 때 더 효과적입니다.
/// 
/// > Tip: 더 정확한 개인화를 위해서는 다양한 집중 상황에서의 피드백 데이터를 수집하는 것이 좋습니다.
///
/// ### Creating a Personalizer
///
/// - ``init(modelURL:)``
///
/// ### Performing Personalization
///
/// - ``run(from:)``
final class FocusPersonalizater: Personalizater {
    private let modelURL: URL

    init(modelURL: URL) {
        self.modelURL = modelURL
    }

    func run(from userTrainingDataList: [UserTrainingData]) async throws -> Bool {
        do {
            let batchProvider = TrainingDataConverter.makeBatchProvider(from: userTrainingDataList)
            try await makeUpdateTask(batchProvider: batchProvider)
            return true
        } catch {
            print("Error: \(error.localizedDescription)")
            return false
        }
    }

    private func makeUpdateTask(batchProvider: MLArrayBatchProvider) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let configuration = MLModelConfiguration()
            configuration.computeUnits = .all

            let handlers = MLUpdateProgressHandlers(
                forEvents: [.trainingBegin, .miniBatchEnd, .epochEnd],
                progressHandler: { context in
                    let event = context.event
                    print("🔹 \(event)")
                    if event == .miniBatchEnd {
                        if let loss = context.metrics[.lossValue] {
                            print("미니배치 손실값: \(loss)")
                        }
                    }
                },
                completionHandler: { context in
                    Task {
                        do {
                            try await self.saveUpdatedModel(context: context)
                            print("✅ 학습 완료")
                            continuation.resume()
                        } catch {
                            print("⛔️ 모델 저장 실패: \(error)")
                            continuation.resume(throwing: error)
                        }
                    }
                }
            )

            do {
                let updateTask = try MLUpdateTask(
                    forModelAt: modelURL,
                    trainingData: batchProvider,
                    configuration: configuration,
                    progressHandlers: handlers
                )
                updateTask.resume()
            } catch {
                print("❌ UpdateTask 생성 오류: \(error)")
                continuation.resume(throwing: error)
            }
        }
    }

    private func saveUpdatedModel(context: MLUpdateContext) async throws {
        let updatedModel = context.model

        do {
            // Ensure the directory exists
            if !FileManager.default.fileExists(
                atPath: Configuration.tempUpdatedModelURL
                    .deletingLastPathComponent()
                    .path
            ) {
                try FileManager.default.createDirectory(
                    at: Configuration.tempUpdatedModelURL
                        .deletingLastPathComponent(),
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }

            // Save the updated model to temporary filename.
            try updatedModel.write(to: Configuration.tempUpdatedModelURL)
            _ = try FileManager.default.replaceItemAt(
                Configuration.updatedModelURL,
                withItemAt: Configuration.tempUpdatedModelURL
            )
        } catch {
            print("⛔️ 모델 저장 실패: \(error)")
            return
        }
    }
}
