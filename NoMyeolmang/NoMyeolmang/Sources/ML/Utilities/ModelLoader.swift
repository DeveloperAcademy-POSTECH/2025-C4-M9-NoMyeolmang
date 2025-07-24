//
//  ModelLoader.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/24/25.
//

import CoreML
import Foundation

enum ModelLoader {
    static func loadModel() -> MLModel? {
        let fileManager = FileManager.default
        let url = loadModelURL()
        
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
    
    static func loadModelURL() -> URL {
        let fileManager = FileManager.default
        let modelURL: URL
        
        if fileManager.fileExists(atPath: Configuration.updatedModelURL.path) {
            print("📦 업데이트된 모델 사용: \(Configuration.updatedModelURL.path)")
            modelURL = Configuration.updatedModelURL
        } else {
            guard
                let bundledURL = Bundle.main.url(
                    forResource: Configuration.modelName,
                    withExtension: Configuration.modelCompiledType
                )
            else {
                fatalError("⛔️ 모델 파일을 찾을 수 없습니다.")
            }
            print("📦 번들 모델 사용: \(bundledURL.path)")
            modelURL = bundledURL
        }
        return modelURL
    }
}

