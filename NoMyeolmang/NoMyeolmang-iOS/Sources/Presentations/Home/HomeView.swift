//
//  HomeView.swift
//  NoMyeolmang
//
//  Created by Moo on 7/10/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.isTapped.toggle()
            }) {
                Text(viewModel.isTapped ? "집중 모드 ON" : "집중 모드 OFF")
            }
        }
    }
}