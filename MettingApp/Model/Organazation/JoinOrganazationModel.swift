//
//  JoinOrganazationModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/24/24.
//

import Foundation

struct JoinOrganazationModel: Codable, Hashable {
    var time: String
    var status: Int
    var code: String
    var message: String
    var result: JoinOrganazationResult
}

struct JoinOrganazationResult: Codable, Hashable {
    var addedMemberId: Int
}
