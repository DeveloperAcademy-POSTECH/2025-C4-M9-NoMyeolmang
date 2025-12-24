//
//  FileSystemModelRepository.swift
//  NoMyeolmang
//
//  Created by Moo on 12/5/25.
//

import CoreML
import Foundation

/// # ``timé/FileSystemModelRepository``
///
/// 파일 시스템을 사용하여 업데이트된 모델을 저장합니다.
///
/// ## Overview
///
/// `FileSystemModelRepository`는 ``ModelRepository`` 프로토콜을 구현하여
/// 업데이트된 ML 모델을 파일 시스템에 저장합니다. 임시 파일에 저장한 후
/// 원자적 파일 교체를 통해 안전하게 모델을 업데이트합니다.
///
/// > Note: 모든 저장 작업은 비동기적으로 수행되며, 에러 발생 시 적절한 예외를 throw합니다.
///
/// ## Topics
///
/// ### Model Operations
///
/// - ``save(from:)``
final class FileSystemModelRepository: ModelRepository {
    func save(from context: MLUpdateContext) async throws {
        let updatedModel = context.model
        
        try ensureDirectoryExists()
        try updatedModel.write(to: Configuration.tempUpdatedModelURL)
        try replaceModel()
    }
    
    private func ensureDirectoryExists() throws {
        let directoryURL = Configuration.tempUpdatedModelURL.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            try FileManager.default.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
    }
    
    private func replaceModel() throws {
        _ = try FileManager.default.replaceItemAt(
            Configuration.updatedModelURL,
            withItemAt: Configuration.tempUpdatedModelURL
        )
    }
}
