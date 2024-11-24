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
    var meetingService: MeetingServiceType { get set }
}

class Services: ServicesType {
    var organazationService: OrganazationServiceType
    var meetingService: MeetingServiceType
    
    init() {
        self.organazationService = OrganazationService()
        self.meetingService = MeetingService()
    }
}

class StubServices: ServicesType {
    var organazationService: OrganazationServiceType = StubOrganazationService()
    var meetingService: MeetingServiceType = StubMeetingService()
}
