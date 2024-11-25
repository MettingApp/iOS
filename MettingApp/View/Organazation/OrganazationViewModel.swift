//
//  OrganazationViewModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/15/24.
//

import Foundation
import Combine

struct Organazation {
    var title: String
    var subTitle: String
    var description: String
}

class OrganazationViewModel: ObservableObject {
    
    enum Action {
        case createOrganazation(Organazation)
    }

    @Published var phase: Phase = .notRequested
    @Published var isPresented: Bool = false
    @Published var alertText: String = ""
    @Published var inviteCode: String = ""
    @Published var organazation: Organazation = .init(title: "", subTitle: "", description: "")
    @Published var organazationData: [OrganazationContent] = []
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case let .createOrganazation(organazation):
            phase = .loading
            container.services.organazationService.createOrganazation(organazation)
                .sink { [weak self] completion in
                    if case .failure = completion {
                        self?.phase = .error
                        self?.isPresented = true
                        self?.alertText = "조직 생성 실패!"
                    }
                } receiveValue: { [weak self] result in
                    self?.phase = .success
                    self?.isPresented = true
                    self?.inviteCode = result.result.inviteCode
                    self?.alertText = "조직 생성 성공!\n초대 코드 : \(result.result.inviteCode)"
                }.store(in: &subscriptions)

        }
    }
}
