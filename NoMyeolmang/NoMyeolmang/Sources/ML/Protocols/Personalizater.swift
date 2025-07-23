//
//  FocusPersonalizater.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/23/25.
//

import CoreML
import Foundation

protocol Personalizater {
    func run(from userTrainingDataList: [UserTrainingData] ) -> Bool
}
