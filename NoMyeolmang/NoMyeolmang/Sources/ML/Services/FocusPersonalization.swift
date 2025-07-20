import CoreML

class FocusPersonalizator {

    private var lastContext: MLUpdateContext
    private var dataList: [UserData] = []

    init() {
        self.lastContext = MLUpdateContext()
    }

    func run(predictor: FocusScorePredictor) {

        // 0. 모델 레이어 확인하기
        //        checkModelLayer()

        // 1. 최근 저장된 사용자 데이터 불러오기
        print("(2) 사용자 최근 10개 데이터 불러오기")
        self.dataList = loadUserData()
        print("(2)-2 ✅ count:", dataList.count)

        // 2. 사용자 데이터 -> MLBatchProvider로 만들기 (모델의 입력 형식)
        let batchProvider = makeBatchProvider()
        //        checkBatchProvider(batchProvider: batchProvider)

        // 3. updateTask resume
        if let updateTask = makeUpdateTask(
            batchProvider: batchProvider,
            predictor: predictor
        ) {
            updateTask.resume()
        } else {
            print("⛔️ 모델 업데이트 실패")
        }

    }

    func checkModelLayer() {
        do {
            let config = MLModelConfiguration()
            guard
                let modelURL = Bundle.main.url(
                    forResource: Constants.modelName,
                    withExtension: Constants.modelCompiledType
                )
            else {
                print(
                    "⛔️ 모델 URL을 찾을 수 없습니다. 이름: \(Constants.modelName).\(Constants.modelCompiledType)"
                )
                return
            }
            let model = try MLModel(contentsOf: modelURL, configuration: config)

            print("📥 [입력 키 목록]")
            for input in model.modelDescription.inputDescriptionsByName {
                print("  • \(input.key): \(input.value)")
            }

            print("📤 [출력 키 목록]")
            for output in model.modelDescription.outputDescriptionsByName {
                print("  • \(output.key): \(output.value)")
            }
        } catch {
            print("⛔️ 모델 로드 또는 설명 조회 실패: \(error)")
        }
    }

    func makeBatchProvider() -> MLArrayBatchProvider {
        var featureProviders: [MLFeatureProvider] = []

        for data in dataList {
            // 1. 사용자 데이터 -> MultiArray로 만들기 (모델의 입력 형식)
            let (inputMA, labelMA) = self.makeMultiArray(data: data)

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

    func checkBatchProvider(batchProvider: MLArrayBatchProvider) {
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

    func makeMultiArray(data: UserData) -> (
        input: MLMultiArray, label: MLMultiArray
    ) {
        guard let inputArray = self.makeInputMultiArray(data: data.input),
            let labelArray = self.makeLabelMultiArray(data: data.label)
        else {
            fatalError("⛔️ MultiArray 생성 실패: 입력 또는 라벨 배열 생성에 실패했습니다.")
        }
        return (input: inputArray, label: labelArray)
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

    func makeFeatureValue(input: MLMultiArray, label: MLMultiArray) -> (
        input: MLFeatureValue, label: MLFeatureValue
    ) {
        let inputValue = MLFeatureValue(multiArray: input)
        let labelValue = MLFeatureValue(multiArray: label)
        return (input: inputValue, label: labelValue)
    }

    func makeFeatureProvider(input: MLFeatureValue, label: MLFeatureValue)
        -> MLFeatureProvider?
    {
        let dict: [String: MLFeatureValue] = [
            Constants.inputName: input, Constants.outputName: label,
        ]
        let featureProvider = try? MLDictionaryFeatureProvider(dictionary: dict)
        return featureProvider
    }

    func makeUpdateTask(
        batchProvider: MLArrayBatchProvider,
        predictor: FocusScorePredictor
    ) -> MLUpdateTask? {

        let modelURL = loadModelURL()

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
                self.lastContext = context
                print(
                    "✅ 업데이트Task 끝: \(context.event) \(context.parameters)"
                )
                // 4. save model
                self.saveUpdatedModel()

                // 5. resave model
                self.resave(predictor: predictor)
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

    func saveUpdatedModel() {
        let updatedModel = self.lastContext.model

        do {
            print("🔹 모델 저장 로직 진입")

            // Ensure the directory exists
            if !FileManager.default.fileExists(
                atPath: Constants.tempUpdatedModelURL.deletingLastPathComponent()
                    .path
            ) {
                try FileManager.default.createDirectory(
                    at: Constants.tempUpdatedModelURL
                        .deletingLastPathComponent(),
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }

            // Save the updated model to temporary filename.
            try updatedModel.write(to: Constants.tempUpdatedModelURL)
            print("✅ 모델 저장 완료")

            _ = try FileManager.default.replaceItemAt(
                Constants.updatedModelURL,
                withItemAt: Constants.tempUpdatedModelURL
            )
            print(
                "✅ Updated model saved to:\n\t\(Constants.updatedModelURL)"
            )

        } catch {
            print("⛔️ 모델 저장 실패: \(error)")
            return
        }
        print("모델 저장 완료")
    }

    func resave(predictor: FocusScorePredictor) {
        print("모델 교체 진입")
        if let updatedModel = loadModel(url: Constants.updatedModelURL) {
            predictor.model = updatedModel
            print("✅ 모델 교체 성공!")
        } else {
            print("⛔️ 모델 교체 실패!")
        }
    }
}
