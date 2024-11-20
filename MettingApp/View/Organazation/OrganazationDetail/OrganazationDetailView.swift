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
        ScrollView(.vertical) {
            VStack {
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
                Spacer()
            }
            .padding(.vertical, 20)
        }
    }
}

#Preview {
    OrganazationDetailView(viewModel: .init(container: .init(services: StubServices())))
}
