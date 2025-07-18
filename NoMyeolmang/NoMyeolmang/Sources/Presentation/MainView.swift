//
//  MainView.swift
//  NoMyeolmang
//
//  Created by Moo on 7/15/25.
//

import AppKit
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.sRGB, white: 0.95, opacity: 1),
                    Color(.sRGB, white: 0.85, opacity: 1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white.opacity(0.18))
                        .background(
                            VisualEffectBlur(
                                material: .hudWindow,
                                blendingMode: .withinWindow
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1.2)
                        )
                        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 8)
                    
                    VStack(spacing: 28) {
                        Text("집중력 입력값")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                        VStack(spacing: 18) {
                            GlassInputRow(
                                icon: "eye",
                                color: .blue,
                                label: "눈 깜빡임",
                                text: $viewModel.blinkCount,
                                placeholder: "3~20"
                            )
                            GlassInputRow(
                                icon: "person.crop.square",
                                color: .green,
                                label: "얼굴/신체 인식",
                                text: $viewModel.faceBodyPresent,
                                placeholder: "0.0~1.0"
                            )
                            GlassInputRow(
                                icon: "iphone",
                                color: .orange,
                                label: "핸드폰 사용",
                                text: $viewModel.phonePresent,
                                placeholder: "0.0~1.0"
                            )
                            GlassInputRow(
                                icon: "clock",
                                color: .purple,
                                label: "경과 시간(분)",
                                text: $viewModel.elapsedTime,
                                placeholder: "1~30"
                            )
                        }
                        .padding(.horizontal, 8)
                        
                        // 사용자 입력 스코어 Picker
                        VStack(spacing: 8) {
                            Text("실제 집중력 점수 (1~5)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Picker("실제 집중력 점수", selection: $viewModel.userScore) {
                                ForEach(1...5, id: \.self) { score in
                                    Text("\(score)").tag(score)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 220)
                        }
                        .padding(.top, 4)
                        
                        Button(action: {
                            viewModel.predict()
                        }) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                Text("예측하기")
                                    .fontWeight(.bold)
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.accentColor.opacity(0.85),
                                        Color.blue.opacity(0.85)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .blue.opacity(0.13), radius: 6, x: 0, y: 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                            .padding(.horizontal, 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .alert(isPresented: $viewModel.showAlert) {
                            Alert(
                                title: Text("입력 오류"),
                                message: Text(viewModel.errorMessage ?? "알 수 없는 오류"),
                                dismissButton: .default(Text("확인"))
                            )
                        }
                        
                        Button(action: {
                            viewModel.personalize()
                        }) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                Text("개인화시키기")
                                    .fontWeight(.bold)
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.accentColor.opacity(0.85),
                                        Color.blue.opacity(0.85)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .blue.opacity(0.13), radius: 6, x: 0, y: 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                            .padding(.horizontal, 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            viewModel.checkModelLayer()
                        }) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                Text("레이어 체크하기")
                                    .fontWeight(.bold)
                            }
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.accentColor.opacity(0.85),
                                        Color.blue.opacity(0.85)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .blue.opacity(0.13), radius: 6, x: 0, y: 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
                            )
                            .padding(.horizontal, 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        
                        if let result = viewModel.predictionResult {
                            VStack(spacing: 8) {
                                Divider().padding(.vertical, 4)
                                Text("예측 집중력 점수")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text(String(format: "%.2f", result))
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.accentColor)
                                    .padding(.top, -4)
                            }
                            .transition(.opacity)
                        }
                    }
                    .padding(36)
                }
                .frame(maxWidth: 400)
                Spacer()
            }
        }
    }
}

// GlassInputRow, VisualEffectBlur는 기존과 동일
struct GlassInputRow: View {
    let icon: String
    let color: Color
    let label: String
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 28)
            Text(label)
                .font(.system(size: 15, weight: .semibold))
                .frame(width: 100, alignment: .leading)
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.35))
                        .blur(radius: 0.2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                )
                .frame(width: 80)
        }
    }
}

struct VisualEffectBlur: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

#Preview {
    MainView()
}
