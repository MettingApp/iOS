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
        case joinOrganazation(String)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var organazationData: [OrganazationContent] = []
    @Published var scheduleData: [ScheduleModel] = [ScheduleModel(title: "학술제 회의", time: "4시간 33분", date: "2024.11.11 09:23PM"),ScheduleModel(title: "학술제 회의", time: "4시간 33분", date: "2024.11.11 09:23PM"),ScheduleModel(title: "학술제 회의", time: "4시간 33분", date: "2024.11.11 09:23PM")]
    @Published var codeText: String = ""
    @Published var joinPhase: Bool = false
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .load:
            self.phase = .loading
            container.services.organazationService.getOrganazation()
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .error
                    }
                } receiveValue: { [weak self] result in
                    self?.organazationData = result.result?.content ?? []
                    self?.phase = .success
                }.store(in: &subscriptions)

            self.phase = .success
        case let .joinOrganazation(inviteCode):
            container.services.organazationService.joinOrganazation(inviteCode: inviteCode)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.joinPhase = false
                    }
                } receiveValue: { [weak self] result in
                    self?.joinPhase = true
                }.store(in: &subscriptions)

        }
    }
}
