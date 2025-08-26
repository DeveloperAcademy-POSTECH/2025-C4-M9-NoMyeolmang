//
//  Configuration.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/23/25.
//

import Foundation

/// # ``timé/Configuration``
///
/// 머신러닝 모델 운영에 필요한 설정 값들과 파일 경로를 중앙 관리합니다.
///
/// `Configuration`은 모델 파일명, 입출력 레이어 이름, 저장 경로 등 모델 운영에 
/// 필요한 모든 설정을 중앙화합니다. ``FocusPersonalizater``가 모델 업데이트 시 사용하는 
/// 경로들과 ``ModelLoader``가 모델을 로드할 때 참조하는 설정들을 제공합니다. 
/// 업데이트된 개인화 모델과 임시 모델의 저장 경로를 ``documentsDirectory`` 내에서 
/// 관리하며, 안전한 파일 교체를 지원합니다.
///
/// ### Model Configuration
///
/// - ``modelName``
/// - ``updatedModelName``
/// - ``modelCompiledType``
///
/// ### Model Input/Output Names
///
/// - ``inputName``
/// - ``outputName``
/// - ``updatableOutputName``
///
/// ### File Path Configuration
///
/// - ``documentsDirectory``
/// - ``tempUpdatedModelURL``
/// - ``updatedModelURL``
enum Configuration {
    static let modelName = "FocusScore_Updatable"
    static let updatedModelName = "UpdatedModel"
    static let modelCompiledType = "mlmodelc"
    
    static let inputName = "dense_4_input"
    static let outputName = "Identity"
    static let updatableOutputName = "Identity_true"
    
    static let documentsDirectory: URL = {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("⛔️ Document directory not found.")
        }
        return url
    }()
    
    static let tempUpdatedModelURL = documentsDirectory.appendingPathComponent("TempUpdatedModel.\(modelCompiledType)")
    static let updatedModelURL = documentsDirectory.appendingPathComponent("UpdatedModel.\(modelCompiledType)")
}
