//
//  CreateMeetingModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/24/24.
//

import Foundation
import Combine

struct CreateMeetingModel: Codable, Hashable {
    var time: String
    var status: Int
    var code: String
    var message: String
}
