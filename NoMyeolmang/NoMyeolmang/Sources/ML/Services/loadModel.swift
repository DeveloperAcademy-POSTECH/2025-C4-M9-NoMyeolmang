//
//  loadModel.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/20/25.
//

import CoreML
import Foundation

func loadModel(url: URL) -> MLModel? {
    let fileManager = FileManager.default

    guard fileManager.fileExists(atPath: url.path)
    else {
        print("⛔️ 모델 파일이 존재하지 않음: \(url.path)")
        return nil
    }

    // Create an instance of the updated model.
    let model = try? MLModel(
        contentsOf: url
    )

    return model
}

func loadModelURL() -> URL {
    let fileManager = FileManager.default
    let modelURL: URL

    if fileManager.fileExists(atPath: Constants.updatedModelURL.path) {
        print("📦 업데이트된 모델 사용: \(Constants.updatedModelURL.path)")
        modelURL = Constants.updatedModelURL
    } else {
        guard
            let bundledURL = Bundle.main.url(
                forResource: Constants.modelName,
                withExtension: Constants.modelCompiledType
            )
        else {
            fatalError("⛔️ 모델 파일을 찾을 수 없습니다.")
        }
        print("📦 번들 모델 사용: \(bundledURL.path)")
        modelURL = bundledURL
    }
    return modelURL
}
