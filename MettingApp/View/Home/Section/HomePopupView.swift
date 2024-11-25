//
//  HomePopupView.swift
//  MettingApp
//
//  Created by 정성윤 on 11/12/24.
//

import SwiftUI

struct HomePopupView: View {
    @Binding var isPopup: Bool
    @EnvironmentObject var viewModel: HomeViewModel
    @FocusState var focusState: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            HStack {
                Spacer()
                Button {
                    isPopup = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20)
            
            if !viewModel.joinPhase {
                Image(systemName: "star.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color.pointOriginColor)
                
                VStack(alignment: .center, spacing: 3) {
                    Text("초대코드 입력하기!")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.pointOriginColor)
                    Text("초대코드를 입력하면💬, \n새로운 조직에 들어갈 수 있어요!")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                
                TextField("초대코드를 입력해 주세요", text: $viewModel.codeText)
                    .overlay(alignment: .trailing) {
                        Button {
                            viewModel.send(.joinOrganazation(viewModel.codeText))
                        } label: {
                            Text("📨")
                                .font(.system(size: 20))
                                .padding(.trailing, 10)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 15).fill(.gray.opacity(0.1)))
                    .onSubmit {
                        viewModel.send(.joinOrganazation(viewModel.codeText))
                    }
                    .padding(.bottom, 20)
                    .padding(.horizontal, 30)
            } else {
                Text("조직 가입 성공!")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.isPopup = false
                        }
                    }
            }
        }
        .padding(.vertical, 20)
        .onTapGesture {
            focusState = false
        }
        .background(.white)
        .cornerRadius(15)
        .frame(width: UIScreen.main.bounds.width - 60)
    }
}

struct HomePopup_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPopup: Bool = false
        HomePopupView(isPopup: $isPopup)
            .environmentObject(HomeViewModel(container: .init(services: StubServices())))
    }
}
