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
        
    }
    
    @Published var phase: Phase = .notRequested
    @Published var calendarData: [CalendarModel] = .init()
    @Published var people: [String] = ["성윤", "규탁", "정곤", "승진"]
    private let container: DIContainer
    private var subscriptiions = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        
    }
    
}
