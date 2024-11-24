//
//  organazationModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/12/24.
//

import Foundation

struct OrganazationModel: Codable, Hashable {
    var time: String
    var status: Int
    var code: String
    var message: String
    var result: OrganazationResult?
}

struct OrganazationResult: Codable, Hashable {
    var content: [OrganazationContent]?
    var page: OrganazationPage
}

struct OrganazationContent: Codable, Hashable {
    var id: Int
    var name: String
    var title: String
    var members: [String]
}

struct OrganazationPage: Codable, Hashable {
    var size: Int
    var number: Int
    var totalElements: Int
    var totalPages: Int
}
