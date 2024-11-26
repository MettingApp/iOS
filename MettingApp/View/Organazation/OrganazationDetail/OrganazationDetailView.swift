//
//  OrganazationDetailView.swift
//  MettingApp
//
//  Created by 정성윤 on 11/20/24.
//

import SwiftUI
import MarkdownUI

struct searchModel {
    var title: String
    var url: String
    var description: String
    var image: String
}

struct OrganazationDetailView: View {
    @StateObject var viewModel: OrganazationDetailViewModel
    @State private var selectedData: [CalendarResult] = []
    @State private var isRecord: Bool = false
    @State private var summary: String = ""
    @State private var search: [String] = []
    @State private var selected: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var organazationId: Int
    var color: [Color] = [.red.opacity(0.5), .orange.opacity(0.5), .green.opacity(0.5), .blue.opacity(0.5), .yellow.opacity(0.5), .pink.opacity(0.5)]
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 20))
                                .tint(.black)
                            Text(viewModel.organazationData.name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $isRecord) {
                RecordingView(viewModel: .init(container: .init(services: Services())), isPresented: $isRecord, id: organazationId)
                    .presentationBackground(.black.opacity(0.7))
            }
            .onChange(of: selectedData) {
                if selectedData != [] {
                    viewModel.send(.detailLoad(self.organazationId, self.selectedData[0].meetingId))
                }
            }
            .onChange(of: selected) {
                if selected {
                    self.summary = """
                                    ## AI 어플리케이션 개발 주제 요약:
                                        1. 인공지능을 활용한 애플리케이션 아이디어 발상
                                            * summary: AI를 활용한 앱으로 사용자의 불편을 해소하는 방향으로 아이디어 발상
                                            * result: AI를 활용한 회의 어시스턴트 서비스 개발을 결정
                                            * search: AI를 활용한 회의 어시스턴트 서비스 구현 방법

                                        2. AI 회의 어시스턴트 서비스 기능 및 차별화 아이디어
                                            * summary: 회의 내용 녹음, 텍스트 변환, 캘린더 관리, 자료 조사 지원 등의 기능 제안
                                            * result: AI를 활용한 회의 어시스턴트 서비스의 차별화된 기능 도출
                                            * search: AI를 활용한 회의 어시스턴트 서비스의 기능 구현 방법

                                        3. 다음 회의 일정 및 과제
                                            * summary: 다음 회의는 29일에 예정되며, UI/UX 디자인, 기획, 백엔드 플로우 구현 등의 과제를 분담
                                            * result: 다음 회의는 29일에 학교 카페에서 진행
                                            * search: AI 어플리케이션 개발에 필요한 한국어 STT 모델 파인튜닝 방법

                                    *next meeting*: 29일, 미정, 학교 카페
                                    """
                    self.search = ["AI를 활용한 회의 어시스턴트 서비스 구현 방법", "AI를 활용한 회의 어시스턴트 서비스의 기능 구현 방법", "AI 어플리케이션 개발에 필요한 한국어 STT 모델 파인튜닝 방법"]
                }
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            Color.white
                .onAppear {
                    viewModel.send(.calendarLoad(organazationId))
                    viewModel.send(.load(organazationId))
                }
        case .loading:
            Color.white
        case .error:
            Color.white
        case .success:
            loadedView
                .refreshable {
                    viewModel.send(.calendarLoad(organazationId))
                    viewModel.send(.load(organazationId))
                }
        }
    }
    
    var loadedView: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 20) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.organazationData.members.indices, id: \.self) { index in
                                Circle()
                                    .fill(color[index % viewModel.organazationData.members.count])
                                    .frame(width: 50, height: 50)
                                    .overlay(alignment: .center) {
                                        Text(viewModel.organazationData.members[index])
                                            .font(.system(size: 18, weight: .bold))
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    CalendarView(calenderData: viewModel.calendarData, selectedData: $selectedData, selected: self.$selected)
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 2)
                        .padding(.horizontal, 20)
                    
                    RecommandSearch(search: self.$search)
                    
                    SeperateView()
                        .frame(width: UIScreen.main.bounds.width, height: 20)
                    
                    MarkdownView(descriptions: self.summary)
                        .padding(.horizontal, 20)
                    
                }
                .padding(.vertical, 20)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        isRecord = true
                    } label: {
                        Image(systemName: "mic")
                            .foregroundColor(.white)
                            .font(.system(size: 25, weight: .bold))
                            .padding(10)
                            .background(Circle().fill(.pointOrigin).shadow(radius: 1))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 30)
            }
        }
    }
}

fileprivate struct RecommandSearch: View {
    @Binding var search: [String]
    var url: [searchModel] = [searchModel(title: "Ai 어시스턴트란 무엇인가?", url: "https://botpress.com/ko/blog/what-is-an-ai-assistant", description: "이메일 작성부터 코드 디버깅, 레스토랑 추천까지, AI 비서를 통해 일상적인 워크플로우를 자동화하는 방법을 쉽게 배울 수 있습니다.", image: "test1"), searchModel(title: "AI 회의 어시스턴트와 함께 더 효율적인 협업 환경 만들기", url: "https://www.thumb.is/korean-blog-posts/mastering-meetings-elevating-collaboration-in-the-workplace-with-ai-meeting-assistants", description: "AI 어시스턴트를 사용하여 업무 생산성을 향상하려면 어떻게 해야 할까요?", image: "test2"), searchModel(title: "[STT] On-Device 한국어 Speech to Text 모델 개발|작성자 아기사자", url: "https://blog.naver.com/112fkdldjs/223513947371", description: "sLLM을 이용해 노트북 수준의 디바이스에서 음성으로 사람과 자연스러운 대화를 하는 End2End 모델을 개발하고 있다. 이를 위해서는 매우 가벼운 고성능의 STT 모델이 필요했고, 마침 OpenAI에서 whisper라는 모델이 오픈소스로 풀려있어서 활용할 수 있었다.", image: "test3")]
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text("추천 검색 자료")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
                Button {
                    //TODO: - 더보기
                } label: {
                    Text("더보기 ▷")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(search.indices, id: \.self) { index in
                        Button  {
                            if let url = URL(string: self.url[index].url) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            VStack(alignment: .center, spacing: 10) {
                                HStack {
                                    Text("#검색결과\(index+1)")
                                        .font(.system(size: 10, weight: .heavy))
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 15).fill(.pointOrigin))
                                    Spacer()
                                }
                                .padding(.top, -20)
                                Text("\(self.url[index].title)")
                                    .font(.system(size: 15, weight: .bold))
                                Text("\(self.url[index].description)")
                                    .font(.system(size: 12, weight: .semibold))
                                
                                Image(self.url[index].image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 50)
                                    .opacity(0.7)
                                    .cornerRadius(15)
                            }
                            .frame(width: 150, height: 150)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white).shadow(color: .gray.opacity(0.3), radius: 3, x: 1, y: 1))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
    }
}

fileprivate struct MarkdownView: View {
    var descriptions: String
    
    var body: some View {
        Markdown(descriptions)
    }
}

#Preview {
    OrganazationDetailView(viewModel: .init(container: .init(services: StubServices())), organazationId: 0)
}
