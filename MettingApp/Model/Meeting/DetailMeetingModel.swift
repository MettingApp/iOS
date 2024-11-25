//
//  DetailMeetingModel.swift
//  MettingApp
//
//  Created by 정성윤 on 11/24/24.
//

import Foundation
import Combine

struct DetailMeetingModel: Codable, Hashable {
    var time: String
    var status: Int
    var code: String
    var message: String
    var result: DetailMeetingResult
}

struct DetailMeetingResult: Codable, Hashable {
    var title: String
    var date: String
    var extraContent: String
    var summary: String?
    var recorder: Recorder
}

struct Recorder: Codable, Hashable {
    var fileName: String?
    var recordFile: String?
}
