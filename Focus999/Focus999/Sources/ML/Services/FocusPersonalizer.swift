//
//  FocusPersonalizer.swift
//  NoMyeolmang
//
//  Created by Moo on 12/5/25.
//

import CoreML

/// # ``timé/FocusPersonalizer``
///
/// 사용자 피드백 데이터를 활용하여 머신러닝 모델을 개인화 학습시킵니다.
///
/// `FocusPersonalizer`는 ``UserTrainingData`` 배열을 받아 MLUpdateTask를 통해
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
/// - ``init(modelURL:modelRepository:)``
///
/// ### Performing Personalization
///
/// - ``run(from:)``
final class FocusPersonalizer: Personalizer {
    private let modelURL: URL
    private let modelRepository: ModelRepository

    init(modelURL: URL, modelRepository: ModelRepository) {
        self.modelURL = modelURL
        self.modelRepository = modelRepository
    }

    func run(from userTrainingDataList: [UserTrainingData]) async throws {
        let batchProvider = TrainingDataConverter.makeBatchProvider(from: userTrainingDataList)
        try await makeUpdateTask(batchProvider: batchProvider)
    }

    private func makeUpdateTask(batchProvider: MLArrayBatchProvider) async throws {
        try await withCheckedThrowingContinuation { continuation in
            let configuration = makeModelConfiguration()
            let handlers = makeProgressHandlers(continuation: continuation)

            do {
                let updateTask = try MLUpdateTask(
                    forModelAt: modelURL,
                    trainingData: batchProvider,
                    configuration: configuration,
                    progressHandlers: handlers
                )
                updateTask.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private func makeModelConfiguration() -> MLModelConfiguration {
        let configuration = MLModelConfiguration()
        configuration.computeUnits = .all
        return configuration
    }

    private func makeProgressHandlers(continuation: CheckedContinuation<Void, Error>) -> MLUpdateProgressHandlers {
        MLUpdateProgressHandlers(
            forEvents: [.trainingBegin, .miniBatchEnd, .epochEnd],
            progressHandler: { _ in },
            completionHandler: { context in
                Task {
                    do {
                        try await self.modelRepository.save(from: context)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        )
    }
}
