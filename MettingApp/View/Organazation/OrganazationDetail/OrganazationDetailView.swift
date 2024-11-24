//
//  OrganazationDetailView.swift
//  MettingApp
//
//  Created by 정성윤 on 11/20/24.
//

import SwiftUI
import MarkdownUI

struct OrganazationDetailView: View {
    @StateObject var viewModel: OrganazationDetailViewModel
    @State private var selectedData: [CalendarResult] = []
    @State private var isRecord: Bool = false
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
                RecordingView(viewModel: .init(container: .init(services: Services())), isPresented: $isRecord)
                    .presentationBackground(.black.opacity(0.7))
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            Color.white
                .onAppear {
                    viewModel.send(.load(organazationId))
                    viewModel.send(.calendarLoad(organazationId))
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
                    
                    CalendarView(calenderData: viewModel.calendarData, selectedData: $selectedData)
                        .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 2)
                        .padding(.horizontal, 20)
                    
                    RecommandSearch()
                    
                    SeperateView()
                        .frame(width: UIScreen.main.bounds.width, height: 20)
                    
                    MarkdownView(descriptions: """
                                    ## Topic Summary:
                                    1. 홍보 및 일본의 자리에 대한 의혹
                                       * **Summary**: 회의 참여자들이 홍보 및 일본의 자리에 대한 의혹에 대해 토론함
                                       * **Result**: 홍보 및 의혹에 대한 논의가 계속될 것으로 보임
                                       * **Search**: 홍보 및 의혹 관련 사례 연구
                                    
                                    2. 저씨의 주장과 의견 제시
                                       * **Summary**: 저씨가 주장하고 의견을 제시하는 내용에 대한 토론
                                       * **Result**: 저씨의 주장이 회의에 영향을 미칠 것으로 예상됨
                                       * **Search**: 저씨의 주장에 대한 추가 정보
                                    
                                    3. 홍빛과 홍병에 대한 논의
                                       * **Summary**: 홍빛과 홍병에 대한 토론 및 결론 도출
                                       * **Result**: 홍빛과 홍병에 대한 조치가 필요함
                                       * **Search**: 홍빛 및 홍병 관련 전략
                                    
                                    ## Next Meeting:
                                    이번주 금요일 오후 2시
                                    """)
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
        Markdown(descriptions)
    }
}

#Preview {
    OrganazationDetailView(viewModel: .init(container: .init(services: StubServices())), organazationId: 0)
}
