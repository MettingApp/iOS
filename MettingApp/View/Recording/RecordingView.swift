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
                Text(viewModel.isRecording ? "녹음 중 🎬" : "녹음 정지 ✋🏻")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.white)
                    .overlay(alignment: .topLeading) {
                        if !viewModel.isRecording {
                            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            let fileURL = directory.appendingPathComponent("recording.wav")
                            if FileManager.default.fileExists(atPath: fileURL.path) {
                                Button {
                                    //TODO: - 추가 입력사항 입력 받기
                                } label: {
                                    Text("녹음된 내용 \nAi로 요약하기 👉🏻")
                                        .foregroundColor(.primary)
                                        .font(.system(size: 15, weight: .semibold))
                                        .multilineTextAlignment(.leading)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 15).fill(.white))
                                        .padding(.top, -70)
                                        .padding(.leading, -80)
                                        .overlay(alignment: .bottomTrailing) {
                                            Text("▼")
                                                .rotationEffect(.degrees(-20))
                                                .font(.system(size: 20))
                                                .foregroundColor(.white)
                                        }
                                }
                            }
                        }
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
            .padding(.vertical, 20)
            .padding(.horizontal, 30)
        }
    }
}

struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isP: Bool = true
        RecordingView(viewModel: .init(container: .init(services: StubServices())), isPresented: $isP)
    }
}
