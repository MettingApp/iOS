//
//  HomeView.swift
//  MettingApp
//
//  Created by 정성윤 on 11/12/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            Color.white
                .onAppear { viewModel.send(.load) }
        case .loading:
            Color.white
                .overlay {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
        case .error:
            Color.white
        case .success:
            loadedView
        }
    }
    
    var loadedView: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 20) {
                header
                
                middle
                
                SeperateView()
                    .frame(width: UIScreen.main.bounds.width, height: 20)
                
                footer
            }
        }
    }
    
    var header: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack(spacing: 20) {
                Circle()
                    .fill(.black)
                    .frame(width: 30, height: 30)
                VStack(alignment: .leading, spacing: 3) {
                    Text("안녕하세요, ").foregroundColor(.primary) + Text("정곤님!").foregroundColor(.pointColor)
                    Text("MOTE")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.primary)
                }
                .font(.system(size: 15, weight: .semibold))
                Spacer()
                Button  {
                    //TODO: - 초대코드 팝업 열기
                } label: {
                    VStack {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.primary)
                        Text("초대코드")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .shadow(radius: 2)
                }
            }
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("학술제 회의, 09:00까지")
                        .foregroundColor(.primary)
                        .font(.system(size: 15, weight: .regular))
                    Group {
                        Text("6시간 22분 ")
                            .font(.system(size: 18, weight: .bold))
                        +
                        Text("남았습니다!")
                            .font(.system(size: 18, weight: .regular))
                    }
                    .foregroundColor(.pointColor)
                }
                Spacer()
                LoadingView(url: "bell", size: [130, 130])
                    .padding(.trailing, -10)
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 30)
    }
    
    var middle: some View {
        VStack(alignment: .leading, spacing: 30) {
            Button {
                //TODO: - 새로운 조직 만들기
            } label: {
                HStack {
                    Text("새로운 조직 만들기")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("Create +")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.pointOpacityColor))
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 50)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.pointColor))
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
            .padding(.horizontal, 30)
            
            Text("조직")
                .foregroundColor(.primary)
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 30)
                .padding(.bottom, -10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.organazationData.indices, id: \.self) { index in
                        OrganazationViewCell(model: viewModel.organazationData[index])
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
            }
        }
    }
    
    var footer: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("일정 임박")
                .foregroundColor(.primary)
                .font(.system(size: 18, weight: .bold))
            
            ProgressView(value: 30, total: 100)
                .progressViewStyle(.linear)
                .tint(.pointColor)
                .overlay(alignment: .topTrailing) {
                    Text("30%")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.pointColor)
                        .padding(.top, -20)
                }
                
            ForEach(viewModel.scheduleData.indices, id:\.self) { index in
                HStack(spacing: 20) {
                    Circle()
                        .fill(Color.pointColor)
                        .frame(width: 20, height: 20)
                        .overlay(alignment: .center) {
                            Text("\(index + 1)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(viewModel.scheduleData[index].title)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.primary)
                        Text(viewModel.scheduleData[index].time)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text(viewModel.scheduleData[index].date)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 10)
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    HomeView(viewModel: .init(container: .init(services: StubServices())))
}