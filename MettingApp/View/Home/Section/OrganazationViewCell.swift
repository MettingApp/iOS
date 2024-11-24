//
//  OrganazationViewCell.swift
//  MettingApp
//
//  Created by 정성윤 on 11/12/24.
//

import SwiftUI

struct OrganazationViewCell: View {
    var model: OrganazationContent
    var color: [Color] = [.red.opacity(0.5), .orange.opacity(0.5), .green.opacity(0.5), .blue.opacity(0.5), .yellow.opacity(0.5), .pink.opacity(0.5)]
    
    var body: some View {
        NavigationLink(destination: OrganazationDetailView(viewModel: .init(container: .init(services: Services())), organazationId: model.id)) {
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
                                        .foregroundColor(.primary)
                                }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            .background(.white)
            .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height / 6)
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 15).fill(.clear).stroke(Color.pointOpacity)
            }
        }
    }
}
//
//#Preview {
//    OrganazationViewCell(model: OrganazationModel(title: "학술제 회의(미나리무침)", subTitle: "1등 해보자!!", people: ["승진","정곤", "성윤", "규탁"], date: "2024년 11월 11일 생성"))
//}
