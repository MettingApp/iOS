//
//  MeetingService.swift
//  MettingApp
//
//  Created by 정성윤 on 11/24/24.
//

import Foundation
import Combine

struct CreateMeetingRequest: Encodable {
    var date: String
    var extraContent: String
    var title: String
    var fileName: String
    var category: String
    var members: [String]
}

protocol MeetingServiceType {
    func createMeeting(id: Int, fileData: Data?, request: CreateMeetingRequest) -> AnyPublisher<CreateMeetingModel, Error>
    func detailLoad(id: Int, meetingId: Int) -> AnyPublisher<DetailMeetingModel,Error>
}

class MeetingService: MeetingServiceType {
    var subscriptions = Set<AnyCancellable>()
    func createMeeting(id: Int, fileData: Data?, request: CreateMeetingRequest) -> AnyPublisher<CreateMeetingModel, any Error> {
        Future<CreateMeetingModel, Error> { promise in
            Alamofire().multipartAlamofire(url: "\(APIEndpoint.createMeeting.urlString)\(id)", fileData: fileData, request: request)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("파일 전송 성공")
                    case let .failure(error):
                        print("파일 전송 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: CreateMeetingModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
    func detailLoad(id: Int, meetingId: Int) -> AnyPublisher<DetailMeetingModel, any Error> {
        Future<DetailMeetingModel, Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.detailMeeting.urlString)\(id)?meetingId=\(meetingId)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("미팅 상세조회 성공")
                    case let .failure(error):
                        print("미팅 상세조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: DetailMeetingModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
}

class StubMeetingService: MeetingServiceType {
    
    
    func createMeeting(id: Int, fileData: Data?, request: CreateMeetingRequest) -> AnyPublisher<CreateMeetingModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func detailLoad(id: Int, meetingId: Int) -> AnyPublisher<DetailMeetingModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
}
