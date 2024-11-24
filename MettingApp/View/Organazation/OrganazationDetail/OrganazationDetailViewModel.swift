//
//  OrganazationDetailViewModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/20/24.
//

import Foundation
import Combine

class OrganazationDetailViewModel: ObservableObject {
    
    enum Action {
        case load(Int)
        case calendarLoad(Int)
    }
    
    @Published var phase: Phase = .notRequested
    @Published var calendarData: [CalendarResult] = []
    @Published var organazationData: OrganazationDetailResult = .init(name: "", title: "", description: "", members: [])
    private let container: DIContainer
    private var subscriptiions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case let .load(id):
            self.phase = .loading
            container.services.organazationService.getDetailOrganazation(id: id)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .error
                    }
                } receiveValue: { [weak self] result in
                    self?.organazationData = result.result
                    self?.phase = .success
                }.store(in: &subscriptiions)
            
        case let .calendarLoad(id):
            self.phase = .loading
            container.services.organazationService.getCalendar(id: id)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .error
                    }
                } receiveValue: { [weak self] result in
                    self?.calendarData = result.result
                    self?.phase = .success
                }.store(in: &subscriptiions)
        }
    }
    
}
