//
//  organazationModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/12/24.
//

import Foundation

struct OrganazationModel: Codable, Hashable {
    var title: String
    var subTitle: String
    var people: [String]
    var date: String
}
