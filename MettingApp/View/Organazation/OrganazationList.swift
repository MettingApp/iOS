//
//  OrganazationList.swift
//  MettingApp
//
//  Created by 정성윤 on 11/15/24.
//

import SwiftUI

struct OrganazationList: View {
    @StateObject var viewModel: OrganazationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        contentView
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 20))
                                .tint(.black)
                            Text("조직")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //TODO: - 검색
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .tint(.black)
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
                    viewModel.phase = .success
                }
        case .loading:
            LoadingView(url: "", size: [150,150])
        case .error:
            Color.white
        case .success:
            loadedView
        }
    }
    
    var loadedView: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .center, spacing: 20) {
                NavigationLink(destination: OrganazationCreateView(viewModel: .init(container: .init(services: Services())))) {
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
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.pointOriginColor))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                
                Spacer()
                
                HStack {
                    Text("조직")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                    Text("날짜순 ▽")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
                VStack(spacing: 20) {
                    ForEach(viewModel.organazationData.indices, id: \.self) { index in
                        OrganazationListCell(model: viewModel.organazationData[index])
                    }
                }
                .padding(.vertical, 10)
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 30)
        }
    }
}

fileprivate struct OrganazationListCell: View {
    var model: OrganazationContent
    var color: [Color] = [.red.opacity(0.5), .orange.opacity(0.5), .green.opacity(0.5), .blue.opacity(0.5), .yellow.opacity(0.5), .pink.opacity(0.5)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(model.name)
                .foregroundColor(.primary)
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 10)
            Text(model.title)
                .foregroundColor(.gray)
                .font(.system(size: 15, weight: .semibold))
                .padding(.horizontal, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(model.members.indices, id: \.self) { index in
                        Circle()
                            .fill(color[index % model.members.count])
                            .frame(width: 30, height: 30)
                            .overlay(alignment: .center) {
                                Text(model.members[index])
                                    .font(.system(size: 13, weight: .semibold))
                            }
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .background(.white)
        .frame(height: UIScreen.main.bounds.height / 6)
        .padding(10)
        .overlay {
            RoundedRectangle(cornerRadius: 15).fill(.clear).stroke(Color.pointOpacity)
        }
    }
}

#Preview {
    OrganazationList(viewModel: .init(container: .init(services: StubServices())))
}
