//
//  APIEndpoint.swift
//  MettingApp
//
//  Created by 정성윤 on 11/23/24.
//

import Foundation

enum APIEndpoint: String, CaseIterable {
    case refresh
    case createOrganazation
    case getOrganazation
    case getDetailOrganazation
    case joinOrganazation
    case getCalendar
    
    var urlString: String {
        switch self {
        case .refresh:
            return ""
        case .createOrganazation:
            return "http://43.200.40.86:8080/api/v1/team"
        case .getOrganazation:
            return "http://43.200.40.86:8080/api/v1/team"
        case .getDetailOrganazation:
            return "http://43.200.40.86:8080/api/v1/team/"
        case .joinOrganazation:
            return "http://43.200.40.86:8080/api/v1/team/join"
        case .getCalendar:
            return "http://43.200.40.86:8080/api/v1/meeting/"
        }
    }
}
