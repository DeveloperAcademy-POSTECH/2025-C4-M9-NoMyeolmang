//
//  ReportPopoverView.swift
//  NoMyeolmang
//
//  Created by gabi on 7/28/25.
//

import SwiftUI

struct ReportPopoverView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var viewModel: ReportViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            PopoverReportTimeView(
                goalTime: viewModel.maxDistance,
                focusTime: viewModel.focusTime
            )
            .padding(.top, 32)
            
            VStack(spacing: 0) {
                Button {
                    coordinator.push(.timer)
                } label: {
                    Text("다시 시작하기")
                        .modifier(PopoverButtonModifier())
                }
                .buttonStyle(.plain)
                
                Button {
                    coordinator.popToRoot()
                } label: {
                    Text("탐사 종료하기")
                        .modifier(PopoverButtonModifier())
                }
                .buttonStyle(.plain)
                .padding(.top, 5)
            }
            .padding(.top, 42)
            .padding(.bottom, 20)
        }
        .modifier(PopoverBgModifier())
        .onAppear {
            viewModel.calDistanceTime()
        }
    }
}
