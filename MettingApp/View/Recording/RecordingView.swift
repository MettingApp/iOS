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
    
    var id: Int
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
                    recordingView(isPresented: $isPresented, isSend: $isSend, id: id)
                        .environmentObject(viewModel)
                } else {
                    recordToServerView(isPresented: $isPresented, id: id)
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
    @State var isDescription: Bool = false
    let questions: [String] = ["카테고리", "회의 제목", "내용 추가"]
    var id: Int

    var body: some View {
        if isDescription {
            VStack(alignment: .center, spacing: 20) {
                Text("녹음된 내용으로\n회의 내용을 요약 중이에요!")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Spacer()
                LoadingView(url: "loading", size: [200, 200])
                Spacer()
            }
        } else {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 20) {
                    ForEach(0..<3, id: \.self) { index in
                        RecordingQuestionView(title: questions[index], text: index == 0 ? $viewModel.answer.category :
                                                index == 1 ? $viewModel.answer.title :
                                                $viewModel.answer.extraContent)
                    }
                    Spacer()
                    Button {
                        if (viewModel.answer.category != "") && (viewModel.answer.title != "") && (viewModel.answer.extraContent != "") {
                            let date = Date()
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            viewModel.answer.date = formatter.string(from: date)
                            viewModel.answer.fileName = "file.wav"
                            viewModel.answer.members = []
                            viewModel.send(.load(id, viewModel.answer))
                            self.isDescription = true
                        }
                    } label: {
                        VStack(alignment: .center, spacing: 5) {
                            Text("저장 및 다음")
                                .font(.system(size: 15, weight: .bold))
                            Text("저장 한 후에는 수정이 불가합니다")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor((viewModel.answer.category != "") && (viewModel.answer.title != "") && (viewModel.answer.extraContent != "") ? .pointOriginColor : .gray)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
            }
        }
    }
}

fileprivate struct RecordingQuestionView: View {
    var title: String
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.primary)
            
            TextField("\(title)을 입력하세요!", text: $text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
                .lineSpacing(5)
                .frame(height: title == "설명" ? 200 : 40)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 15).fill(.white)
                    .shadow(color: .gray, radius: 2, x: 1, y: 1))
                .multilineTextAlignment(.leading)
        }
    }
}


fileprivate struct recordingView: View {
    @EnvironmentObject var viewModel: RecordingViewModel
    @Binding var isPresented: Bool
    @Binding var isSend: Bool
    
    var id: Int
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
        RecordingView(viewModel: .init(container: .init(services: StubServices())), isPresented: $isP, id: 1)
    }
}
