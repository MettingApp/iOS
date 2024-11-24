//
//  OrganazationCreateView.swift
//  MettingApp
//
//  Created by 정성윤 on 11/15/24.
//

import SwiftUI

struct OrganazationCreateView: View {
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
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 20))
                            .tint(.black)
                    }
                }
            }
            .alert(isPresented: $viewModel.isPresented) {
                Alert(title: Text(viewModel.alertText), message: nil, primaryButton: .default(Text("확인"), action: {
                    if viewModel.phase == .success {
                        dismiss()
                    }
                }), secondaryButton: .default(Text("복사"), action: {
                    let codeToCopy = viewModel.inviteCode
                        UIPasteboard.general.string = codeToCopy
                        if let copiedString = UIPasteboard.general.string {
                            print("클립보드에 복사된 값: \(copiedString)")
                        } else {
                            print("복사 실패")
                        }
                    if viewModel.phase == .success {
                        dismiss()
                    }
                }))
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.phase {
        case .notRequested:
            loadedView
        case .loading:
            LoadingView(url: "", size: [100,100])
        case .error:
            loadedView
        case .success:
            loadedView
                
        }
    }
    
    var loadedView: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 20) {
                ForEach(0..<3, id: \.self) { index in
                    if index == 0 {
                        SectionView(title: "조직명", text: $viewModel.organazation.title)
                    } else if index == 1 {
                        SectionView(title: "소제목", text: $viewModel.organazation.subTitle)
                    } else {
                        SectionView(title: "설명", text: $viewModel.organazation.description)
                    }
                }
                Spacer()
                Button {
                    if (viewModel.organazation.title != "") && (viewModel.organazation.description != "") && (viewModel.organazation.subTitle != "") {
                        viewModel.send(.createOrganazation(viewModel.organazation))
                    }
                } label: {
                    VStack(alignment: .center, spacing: 5) {
                        Text("저장 및 다음")
                            .font(.system(size: 15, weight: .bold))
                        Text("저장 한 후에는 수정이 불가합니다")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor((viewModel.organazation.title != "") && (viewModel.organazation.description != "") && (viewModel.organazation.subTitle != "") ? .pointOriginColor : .gray)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
        }
    }
    
}

fileprivate struct SectionView: View {
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

#Preview {
    OrganazationCreateView(viewModel: .init(container: .init(services: StubServices())))
}
