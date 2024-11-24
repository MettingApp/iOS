//
//  Services.swift
//  MettingApp
//
//  Created by 정성윤 on 11/12/24.
//

import Foundation
import Combine

protocol ServicesType {
    var organazationService: OrganazationServiceType { get set }
}

class Services: ServicesType {
    var organazationService: OrganazationServiceType
    
    init() {
        self.organazationService = OrganazationService()
    }
}

class StubServices: ServicesType {
    var organazationService: OrganazationServiceType = StubOrganazationService()
}
