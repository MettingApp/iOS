//
//  CreateOrganazationModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/23/24.
//

import Foundation

struct CreateOrganazationModel: Codable, Hashable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: CreateOrganazationResult
}

struct CreateOrganazationResult: Codable, Hashable {
    var teamId: Int
    var inviteCode: String
}
