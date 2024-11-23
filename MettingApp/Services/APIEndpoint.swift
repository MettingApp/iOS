//
//  APIEndpoint.swift
//  MettingApp
//
//  Created by 정성윤 on 11/23/24.
//

import Foundation

enum APIEndpoint: String, CaseIterable {
    case refresh
    
    var urlString: String {
        switch self {
        case .refresh:
            return ""
        }
    }
}
