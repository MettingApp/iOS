//
//  HomeViewModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/12/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    enum Action {
        case load
    }
    
    @Published var phase: Phase = .notRequested
    @Published var organazationData: [OrganazationModel] = [OrganazationModel(title: "학술제 회의", subTitle: "1등 해보자!!", people: ["승진","정곤", "성윤", "규탁"], date: "2024년 11월 11일 생성"),OrganazationModel(title: "학술제 회의", subTitle: "1등 해보자!!", people: ["승진","정곤", "성윤", "규탁"], date: "2024년 11월 11일 생성"),OrganazationModel(title: "학술제 회의", subTitle: "1등 해보자!!", people: ["승진","정곤", "성윤", "규탁"], date: "2024년 11월 11일 생성"),OrganazationModel(title: "학술제 회의", subTitle: "1등 해보자!!", people: ["승진","정곤", "성윤", "규탁"], date: "2024년 11월 11일 생성")]
    @Published var scheduleData: [ScheduleModel] = [ScheduleModel(title: "학술제 회의", time: "4시간 33분", date: "2024.11.11 09:23PM"),ScheduleModel(title: "학술제 회의", time: "4시간 33분", date: "2024.11.11 09:23PM"),ScheduleModel(title: "학술제 회의", time: "4시간 33분", date: "2024.11.11 09:23PM")]
    @Published var codeText: String = ""
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .load:
            self.phase = .loading
            //TODO: - 통신
            self.phase = .success
        }
    }
}
