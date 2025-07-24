//
//  FocusPersonalizater.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/23/25.
//

import CoreML

final class FocusPersonalizater: Personalizater {
    private let modelURL: URL

    init(modelURL: URL) {
        self.modelURL = modelURL
    }

    func run(from userTrainingDataList: [UserTrainingData]) -> Bool {

        let batchProvider = makeBatchProvider(from: userTrainingDataList)
        checkBatchProvider(batchProvider: batchProvider)

        if let updateTask = makeUpdateTask(
            batchProvider: batchProvider
        ) {
            updateTask.resume()
        } else {
            print("⛔️ 모델 업데이트 실패")
            return false
        }
        return true
    }

    private func makeBatchProvider(from userTrainingDataList: [UserTrainingData])
        -> MLArrayBatchProvider
    {
        var featureProviders: [MLFeatureProvider] = []

        for data in userTrainingDataList {
            // 1. 사용자 데이터 -> MultiArray로 만들기 (모델의 입력 형식)
            guard let (inputMA, labelMA) = self.makeMultiArray(data: data)
            else {
                print("⛔️ 샘플 스킵됨 (데이터 오류)")
                continue
            }

            // 2. MultiArray -> MLFeatureValue로 만들기
            let (inputFV, labelFV) = self.makeFeatureValue(
                input: inputMA,
                label: labelMA
            )

            // 3. MLFeatureValue -> MLFeatureProvider로 만들기
            if let featureProvider = self.makeFeatureProvider(
                input: inputFV,
                label: labelFV
            ) {
                featureProviders.append(featureProvider)
            } else {
                print("❌ MLFeatureProvider 생성 오류")
            }
        }

        // 4. MLFeatureProvider -> MLBatchProvider로 만들기
        return MLArrayBatchProvider(array: featureProviders)
    }

    private func checkBatchProvider(batchProvider: MLArrayBatchProvider) {
        print("📦 batchProvider 전체 샘플 수: \(batchProvider.count)")

        for i in 0..<batchProvider.count {
            let sample = batchProvider.features(at: i)
            print("🔹 [샘플 \(i)]")

            for feature in sample.featureNames {
                if let value = sample.featureValue(for: feature) {
                    print("    \(feature): \(value)")
                } else {
                    print("    \(feature): nil")
                }
            }
        }
    }

    private func makeMultiArray(data: UserTrainingData) -> (
        input: MLMultiArray, label: MLMultiArray
    )? {
        guard let inputArray = self.makeInputMultiArray(data: data.features),
            let labelArray = self.makeLabelMultiArray(data: data.userScore)
        else {
            print("⛔️ MultiArray 생성 실패: 입력 또는 라벨 배열 생성에 실패했습니다.")
            return nil
        }
        return (input: inputArray, label: labelArray)
    }

    private func makeInputMultiArray(data: Features) -> MLMultiArray? {
        guard
            let inputArray = try? MLMultiArray(
                shape: [1, 6],
                dataType: .float32
            )
        else {
            return nil
        }

        inputArray[0] = NSNumber(
            value: MinMaxScaler.scaleBlink(data.blinkCountPerMin)
        )
        inputArray[1] = NSNumber(
            value: MinMaxScaler.scaleFace(data.faceBodyPresent)
        )
        inputArray[2] = NSNumber(
            value: MinMaxScaler.scalePhone(data.phonePresent)
        )
        inputArray[3] = NSNumber(
            value: MinMaxScaler.scaleTime(data.elapsedTime)
        )
        inputArray[4] = NSNumber(
            value: MinMaxScaler.scaleYawn(data.yawnPerMin)
        )
        inputArray[5] = NSNumber(
            value: MinMaxScaler.scaleLongBlink(data.longBlinkPerMin)
        )
        return inputArray
    }

    private func makeLabelMultiArray(data: Double) -> MLMultiArray? {
        do {
            let labelArray = try MLMultiArray(shape: [1], dataType: .float32)
            labelArray[0] = NSNumber(
                value: data
            )
            return labelArray
        } catch {
            print("❌ MLMultiArray 생성 오류: \(error)")
            return nil
        }
    }

    private func makeFeatureValue(input: MLMultiArray, label: MLMultiArray) -> (
        input: MLFeatureValue, label: MLFeatureValue
    ) {
        let inputValue = MLFeatureValue(multiArray: input)
        let labelValue = MLFeatureValue(multiArray: label)
        return (input: inputValue, label: labelValue)
    }

    private func makeFeatureProvider(input: MLFeatureValue, label: MLFeatureValue)
        -> MLFeatureProvider?
    {
        let dict: [String: MLFeatureValue] = [
            Configuration.inputName: input, Configuration.updatableOutputName: label,
        ]
        let featureProvider = try? MLDictionaryFeatureProvider(dictionary: dict)
        return featureProvider
    }

    private func makeUpdateTask(
        batchProvider: MLArrayBatchProvider
    ) -> MLUpdateTask? {

        let configutaion = MLModelConfiguration()
        configutaion.computeUnits = .all

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
                // 4. save model
                self.saveUpdatedModel(context: context)
            }
        )

        do {
            let updateTask = try MLUpdateTask(
                forModelAt: modelURL,
                trainingData: batchProvider,
                configuration: configutaion,
                progressHandlers: handlers,
            )
            return updateTask
        } catch {
            print("❌ UpdateTask 생성 오류: \(error)")
            return nil
        }
    }

    private func saveUpdatedModel(context: MLUpdateContext) {
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
