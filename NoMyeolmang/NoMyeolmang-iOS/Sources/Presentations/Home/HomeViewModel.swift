//
//  HomeViewModel.swift
//  NoMyeolmang
//
//  Created by Moo on 7/10/25.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @EnvironmentObject private var router: AppRouter
    @Published var isTapped: Bool = false
}
