//
//  Configuration.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/23/25.
//

import Foundation

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
