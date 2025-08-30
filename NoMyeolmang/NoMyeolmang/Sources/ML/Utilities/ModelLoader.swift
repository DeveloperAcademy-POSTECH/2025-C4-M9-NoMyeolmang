//
//  ModelLoader.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/24/25.
//

import CoreML
import Foundation

/// # ``timé/ModelLoader``
///
/// 머신러닝 모델 파일을 로드하고 우선순위에 따라 적절한 모델을 선택합니다.
///
/// `ModelLoader`는 개인화된 모델과 기본 번들 모델 중에서 적절한 모델을 로드합니다.
/// ``loadModelURL()`` 메서드를 통해 우선순위를 결정하며, ``Configuration/updatedModelURL``의 
/// 개인화된 모델이 있으면 우선 사용하고, 없으면 앱 번들의 기본 모델을 사용합니다. 
/// ``loadModel()`` 메서드는 해당 경로의 모델 파일을 실제로 로드하여 MLModel 인스턴스를 
/// 반환하며, ``FocusScorePredictor`` 초기화 시 사용됩니다.
///
/// ### Loading Models
///
/// - ``loadModel()``
/// - ``loadModelURL()``
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
