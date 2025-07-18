import CoreML

class FocusPersonalizator {
    private var documentsDirectory: URL
    private let tempUpdatedModelURL: URL
    private let updatedModelURL: URL

    init() {
        self.documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
        self.tempUpdatedModelURL = documentsDirectory.appendingPathComponent(
            "TempUpdatedModel"
        )
        self.updatedModelURL = documentsDirectory.appendingPathComponent(
            "UpdatedModel"
        )
    }

    func makeBatchProvider(
        inputArray: [MLMultiArray],
        outputArray: [MLMultiArray]
    )
        -> MLArrayBatchProvider
    {
        var featureProviders: [MLFeatureProvider] = []

        // MLFeatureProvier로 만들기
        for (index, inputValue) in inputArray.enumerated() {
            let outputValue = outputArray[index]
            if let provider = makeProvider(
                inputArray: inputValue,
                label: outputValue
            ) {
                // featureProviders 배열에 추가하기
                featureProviders.append(provider)
            }
        }

        return MLArrayBatchProvider(array: featureProviders)
    }

    func makeProvider(inputArray: MLMultiArray, label: MLMultiArray)
        -> MLFeatureProvider?
    {
        let inputValue = MLFeatureValue(multiArray: inputArray)
        let labelValue = MLFeatureValue(multiArray: label)
        //        print("personalize>> input:", inputValue, ", label:", labelValue)

        let dict: [String: MLFeatureValue] = [
            Constants.inputName: inputValue, Constants.outputName: labelValue,
        ]
        let featureProvider = try? MLDictionaryFeatureProvider(dictionary: dict)
        return featureProvider
    }

    func makeInputMultiArray(data: MLModelInput) -> MLMultiArray? {
        do {
            let multiArray = try MLMultiArray(
                shape: [1, 4],
                dataType: .float32
            )
            multiArray[0] = NSNumber(value: Float(data.blinkCountPerMin))
            multiArray[1] = NSNumber(value: Float(data.faceBodyPresent))
            multiArray[2] = NSNumber(value: Float(data.phonePresent))
            multiArray[3] = NSNumber(value: Float(data.elapsedTime))
            return multiArray
        } catch {
            print("❌ MLMultiArray 생성 오류: \(error)")
            return nil
        }
    }

    func makeLabelMultiArray(data: Double) -> MLMultiArray? {
        do {
            let labelArray = try MLMultiArray(shape: [1], dataType: .float32)
            labelArray[0] = NSNumber(value: Float(data))
            return labelArray
        } catch {
            print("❌ MLMultiArray 생성 오류: \(error)")
            return nil
        }
    }

    func makeUpdateTask(
        batchProvider: MLArrayBatchProvider,
        predictor: FocusScorePredictor
    ) {
        do {
            guard
                let modelURL = Bundle.main.url(
                    forResource: "FocusScore_Updatable",
                    withExtension: "mlmodelc"
                )
            else {
                fatalError("⛔️ 모델 파일을 찾을 수 없습니다.")
            }

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
                    print(
                        "✅ 업데이트Task 끝: \(context.event) \(context.parameters)"
                    )

                    self.saveUpdatedModel(
                        context: context,
                        predictor: predictor
                    )
                }
            )

            let updateTask = try MLUpdateTask(
                forModelAt: modelURL,
                trainingData: batchProvider,
                configuration: configutaion,
                progressHandlers: handlers,
            )
            print("✅ 업데이트Task 시작")
            updateTask.resume()
        } catch {
            print("⛔️ 업데이트 실패:", error)
            return
        }

    }

    func saveUpdatedModel(
        context: MLUpdateContext,
        predictor: FocusScorePredictor
    ) {
        let updatedModel = context.model

        do {
            print("🔹 모델 저장 로직 진입")

            // Ensure the directory exists
            if !FileManager.default.fileExists(
                atPath: self.tempUpdatedModelURL.deletingLastPathComponent()
                    .path
            ) {
                do {
                    try FileManager.default.createDirectory(
                        at: self.tempUpdatedModelURL
                            .deletingLastPathComponent(),
                        withIntermediateDirectories: true,
                        attributes: nil
                    )
                    print(
                        "📁 Temp directory created at: \(self.tempUpdatedModelURL.deletingLastPathComponent())"
                    )
                } catch {
                    print("⛔️ 디렉토리 생성 실패: \(error)")
                    return
                }
            }

            // Save the updated model to temporary filename.
            print("updatedModel 건들기 시작... 오류의 서막...")
            print(updatedModel.modelDescription)
            if let writableModel = updatedModel as? MLWritable {
                try writableModel.write(to: self.tempUpdatedModelURL)
                print("✅ 모델 저장 완료")

                do {
                    _ = try FileManager.default.replaceItemAt(
                        self.updatedModelURL,
                        withItemAt: self.tempUpdatedModelURL
                    )
                    print("✅ 모델 교체용 파일 교체 성공")
                    print(
                        "✅ Updated model saved to:\n\t\(self.updatedModelURL)"
                    )
                } catch {
                    print("❌ 파일 교체 실패: \(error)")
                    return
                }

                // 6. 업데이트된 모델 덮어쓰기
                DispatchQueue.main.async {
                    print("모델 교체 진입")
                    if let updatedModel = self.loadUpdatedModel() {
                        predictor.model = updatedModel
                        print("✅ 모델 교체 성공!")
                    } else {
                        print("⛔️ 모델 교체 실패!")
                    }
                }
            }
        } catch {
            print("⛔️ 모델 저장 실패: \(error)")
            return
        }
        print("모델 저장 완료")
    }

    func loadUpdatedModel() -> FocusScore_Updatable? {
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: self.updatedModelURL.path)
        else {
            print("⛔️ 모델 파일이 존재하지 않음: \(self.updatedModelURL.path)")
            return nil
        }

        // Create an instance of the updated model.
        do {
            let model = try? FocusScore_Updatable(
                contentsOf: self.updatedModelURL
            )
            return model
        } catch {
            print("⛔️ 모델 불러오기 실패: \(error)")
            return nil
        }
    }
}
