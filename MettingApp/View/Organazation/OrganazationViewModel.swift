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
        case load
    }

    @Published var phase: Phase = .notRequested
    @Published var organazation: Organazation = .init(title: "", subTitle: "", description: "")
    
    private let container: DIContainer
    private var subscriptions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .load:
            phase = .loading
            
        }
    }
}
