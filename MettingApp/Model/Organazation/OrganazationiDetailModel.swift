//
//  OrganazationiDetailModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/24/24.
//

import Foundation

struct OrganazationiDetailModel: Codable, Hashable {
    var time: String
    var status: Int
    var code: String
    var message: String
    var result: OrganazationDetailResult
}

struct OrganazationDetailResult: Codable, Hashable {
    var name: String
    var title: String
    var description: String
    var members: [String]
}
