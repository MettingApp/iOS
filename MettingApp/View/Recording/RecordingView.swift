//
//  RecordingView.swift
//  MettingApp
//
//  Created by 정성윤 on 11/21/24.
//

import SwiftUI

struct RecordingView: View {
    @StateObject var viewModel: RecordingViewModel
    @Binding var isPresented: Bool
    @State private var isSend: Bool = false
    
    var body: some View {
        ZStack {
            Image("recordingBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            VStack(alignment: .center, spacing: 40) {
                HStack {
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                if !isSend {
                    recordingView(isPresented: $isPresented, isSend: $isSend)
                        .environmentObject(viewModel)
                } else {
                    recordToServerView(isPresented: $isPresented)
                        .environmentObject(viewModel)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 30)
        }
    }
}

fileprivate struct recordToServerView: View {
    @EnvironmentObject var viewModel: RecordingViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("녹음된 내용으로\n회의 내용을 요약 중이에요!")
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            Spacer()
            LoadingView(url: "loading", size: [200, 200])
            Spacer()
        }
    }
}

fileprivate struct recordingView: View {
    @EnvironmentObject var viewModel: RecordingViewModel
    @Binding var isPresented: Bool
    @Binding var isSend: Bool
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Circle()
                .strokeBorder(Color.white.opacity(0.7), lineWidth: 2)
                .frame(width: 200 + viewModel.soundLevel, height: 200 + viewModel.soundLevel)
                .scaleEffect(1 + viewModel.soundLevel)
                .animation(.easeInOut(duration: 0.1), value: viewModel.soundLevel)
                .overlay(
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 200, height: 200)
                        .overlay(alignment: .center) {
                            Image(systemName: "mic")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.gray)
                                .background(.clear)
                        }
                )
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    withAnimation {
                        isSend = true
                    }
                } label: {
                    Text("녹음된 내용 \nAi로 요약하기 👉🏻")
                        .foregroundColor(.primary)
                        .font(.system(size: 15, weight: .semibold))
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 15).fill(.white))
                        .padding(.leading, -80)
                        .overlay(alignment: .bottomTrailing) {
                            Text("▼")
                                .padding(.bottom, -10)
                                .rotationEffect(.degrees(-20))
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                }
                Text(viewModel.isRecording ? "녹음 중 🎬" : "녹음 정지 ✋🏻")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 50) {
                Button {
                    viewModel.send(.startRecording)
                } label: {
                    Image(systemName: "play.circle")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }
                Button {
                    viewModel.send(.stopRecording)
                } label: {
                    Image(systemName: "stop.circle")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            Spacer()
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isP: Bool = true
        RecordingView(viewModel: .init(container: .init(services: StubServices())), isPresented: $isP)
    }
}
