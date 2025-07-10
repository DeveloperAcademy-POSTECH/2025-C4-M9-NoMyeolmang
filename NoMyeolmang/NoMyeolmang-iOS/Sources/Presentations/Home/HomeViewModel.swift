//
//  HomeViewModel.swift
//  NoMyeolmang
//
//  Created by Moo on 7/10/25.
//

import SwiftUI
import Combine      // C가 F보다 먼저 와야 함
import Foundation

final class HomeViewModel: ObservableObject {
    @Published var isTapped: Bool = false
}
