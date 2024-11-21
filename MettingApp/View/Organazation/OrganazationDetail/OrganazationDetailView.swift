//
//  OrganazationDetailView.swift
//  MettingApp
//
//  Created by 정성윤 on 11/20/24.
//

import SwiftUI

struct OrganazationDetailView: View {
    @StateObject var viewModel: OrganazationDetailViewModel
    @State private var selectedData: [CalendarModel] = .init()
    @Environment(\.dismiss) var dismiss
    
    var color: [Color] = [.red.opacity(0.5), .orange.opacity(0.5), .green.opacity(0.5), .blue.opacity(0.5), .yellow.opacity(0.5), .pink.opacity(0.5)]
    
    var body: some View {
        loadedView
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
                            Text("학술제 회의")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            Color.white
                .onAppear {
                    
                }
        case .loading:
            Color.white
        case .error:
            Color.white
        case .success:
            loadedView
        }
    }
    
    var loadedView: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 20) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.people.indices, id: \.self) { index in
                                Circle()
                                    .fill(color[index % viewModel.people.count])
                                    .frame(width: 50, height: 50)
                                    .overlay(alignment: .center) {
                                        Text(viewModel.people[index])
                                            .font(.system(size: 18, weight: .bold))
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    CalendarView(calenderData: viewModel.calendarData, selectedData: $selectedData)
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 2)
                        .padding(.horizontal, 20)
                    
                    RecommandSearch()
                    
                    SeperateView()
                        .frame(width: UIScreen.main.bounds.width, height: 20)
                    
                    MarkdownView(descriptions: "📅 2024년 11월 13일 회의 요약\n\n1. 프로젝트 진행 상황\n\n- UI 디자인: 메인 페이지 디자인 완료, 로그인 화면 수정 예정\n\n- 백엔드 개발: API 서버 배포 완료, 데이터베이스 최적화 진행 중\n\n- iOS 앱 개발: SwiftUI 기반으로 마크다운 뷰 기능 추가 예정")
                        .padding(.horizontal, 20)
                    
                }
                .padding(.vertical, 20)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        //TODO: - 녹음
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
                    ForEach(0...5, id: \.self) { index in
                        Text("검색 조사 결과")
                            .frame(width: 150, height: 150)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white).shadow(color: .gray.opacity(0.3), radius: 3, x: 1, y: 1))
                            .overlay(alignment: .topLeading) {
                                Text("#카테고리")
                                    .font(.system(size: 10, weight: .heavy))
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 15).fill(.pointOrigin))
                                    .padding(.top, -5)
                                    .padding(.leading, -10)
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
        VStack {
            Text(descriptions)
        }
    }
}

#Preview {
    OrganazationDetailView(viewModel: .init(container: .init(services: StubServices())))
}
