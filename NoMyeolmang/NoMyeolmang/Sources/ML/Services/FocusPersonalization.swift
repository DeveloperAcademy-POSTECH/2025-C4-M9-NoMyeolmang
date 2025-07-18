import CoreML

func makeBatchProvider(inputArray: [MLMultiArray], outputArray: [Double])
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

func makeProvider(inputArray: MLMultiArray, label: Double) -> MLFeatureProvider?
{
    let inputValue = MLFeatureValue(multiArray: inputArray)
    let labelValue = MLFeatureValue(double: label)
    //        print("personalize>> input:", inputValue, ", label:", labelValue)

    let dict: [String: MLFeatureValue] = [
        Constants.inputName: inputValue, Constants.outputName: labelValue,
    ]
    let featureProvider = try? MLDictionaryFeatureProvider(dictionary: dict)
    return featureProvider
}

func makeMultiArray(data: MLModelInput) -> MLMultiArray? {
    do {
        let multiArray = try MLMultiArray(shape: [4], dataType: .double)
        multiArray[0] = NSNumber(value: data.blinkCountPerMin)
        multiArray[1] = NSNumber(value: data.faceBodyPresent)
        multiArray[2] = NSNumber(value: data.phonePresent)
        multiArray[3] = NSNumber(value: data.elapsedTime)
        return multiArray
    } catch {
        print("❌ MLMultiArray 생성 오류: \(error)")
        return nil
    }
}

func makeUpdateTask(batchProvider: MLArrayBatchProvider) -> MLUpdateTask? {
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

        let progressHandler = MLUpdateProgressHandlers(
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
                print("✅ 전체 학습 완료")
                saveUpdatedModel(context: context)
            }
        )

        let updateTask = try MLUpdateTask(
            forModelAt: modelURL,
            trainingData: batchProvider,
            configuration: configutaion,
            progressHandlers: progressHandler,
        )

        updateTask.resume()

        return updateTask
    } catch {
        print("⛔️ 업데이트 실패:", error)
        return nil
    }

}
func saveUpdatedModel(context: MLUpdateContext) {
    let updatedModel = context.model
    do {
        print("🔹 모델 저장 로직 진입")

        let fileManager = FileManager.default

        do {
            // Create a directory for the updated model.
            try fileManager.createDirectory(
                at: ModelPaths.tempUpdatedModelURL,
                withIntermediateDirectories: true,
                attributes: nil
            )

            // Save the updated model to temporary filename.
            if let writableModel = updatedModel as? MLWritable {
                try writableModel.write(to: ModelPaths.tempUpdatedModelURL)
            }

            // Replace any previously updated model with this one.
            _ = try fileManager.replaceItemAt(
                ModelPaths.updatedModelURL,
                withItemAt: ModelPaths.tempUpdatedModelURL
            )

            print("Updated model saved to:\n\t\(ModelPaths.updatedModelURL)")
        } catch let error {
            print("Could not save updated model to the file system: \(error)")
            return
        }

        print("✅ 모델 저장 완료")
    } catch {
        print("⛔️ 모델 저장 실패: \(error)")

    }
}

func loadUpdatedModel() -> FocusScore_Updatable? {
    let fileManager = FileManager.default

    guard fileManager.fileExists(atPath: ModelPaths.updatedModelURL.path)
    else {
        print("⛔️ 모델 파일이 존재하지 않음: \(ModelPaths.updatedModelURL.path)")
        return nil
    }

    // Create an instance of the updated model.
    do {
        let model = try? FocusScore_Updatable(
            contentsOf: ModelPaths.updatedModelURL
        )
        return model
    } catch {
        print("⛔️ 모델 불러오기 실패: \(error)")
        return nil
    }
}
