//
//  OrganazationService.swift
//  MettingApp
//
//  Created by 정성윤 on 11/23/24.
//

import Foundation
import Combine

protocol OrganazationServiceType {
    func createOrganazation(_ organazation: Organazation) -> AnyPublisher<CreateOrganazationModel,Error>
    func getOrganazation() -> AnyPublisher<OrganazationModel, Error>
    func joinOrganazation(inviteCode: String) -> AnyPublisher<JoinOrganazationModel, Error>
    func getDetailOrganazation(id: Int) -> AnyPublisher<OrganazationiDetailModel, Error>
    func getCalendar(id: Int) -> AnyPublisher<CalendarModel, Error>
}

class OrganazationService: OrganazationServiceType {
    private var subscriptions = Set<AnyCancellable>()
    
    func createOrganazation(_ organazation: Organazation) -> AnyPublisher<CreateOrganazationModel, any Error> {
        Future<CreateOrganazationModel, Error> { promise in
            let params: [String:Any] = [
                "name": organazation.title,
                "title": organazation.subTitle,
                "description": organazation.description
            ]
            Alamofire().postAlamofire(url: APIEndpoint.createOrganazation.urlString, params: params)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("조직 생성 성공")
                    case let .failure(error):
                        print("조직 생성 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: CreateOrganazationModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)

        }.eraseToAnyPublisher()
    }
    
    func getOrganazation() -> AnyPublisher<OrganazationModel, any Error> {
        Future<OrganazationModel, Error> { promise in
            Alamofire().getAlamofire(url: APIEndpoint.getOrganazation.urlString)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("조직 조회 성공")
                    case let .failure(error):
                        print("조직 조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: OrganazationModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func joinOrganazation(inviteCode: String) -> AnyPublisher<JoinOrganazationModel, any Error> {
        Future<JoinOrganazationModel, Error> { promise in
            let params: [String:Any] = [
                "inviteCode" : inviteCode
            ]
            Alamofire().postAlamofire(url: APIEndpoint.joinOrganazation.urlString, params: params)
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("조직 가입 성공")
                    case let .failure(error):
                        print("조직 가입 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: JoinOrganazationModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func getDetailOrganazation(id: Int) -> AnyPublisher<OrganazationiDetailModel, any Error> {
        Future<OrganazationiDetailModel, Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.getDetailOrganazation.urlString)\(id)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("조직 상세조회 성공")
                    case let .failure(error):
                        print("조직 상세조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: OrganazationiDetailModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func getCalendar(id: Int) -> AnyPublisher<CalendarModel, any Error> {
        Future<CalendarModel, Error> { promise in
            Alamofire().getAlamofire(url: "\(APIEndpoint.getCalendar.urlString)\(id)")
                .sink { completion in
                    switch completion {
                    case .finished:
                        print("캘린더 조회 성공")
                    case let .failure(error):
                        print("캘린더 조회 실패")
                        promise(.failure(error))
                    }
                } receiveValue: { [weak self] (result: CalendarModel) in
                    guard self != nil else { return }
                    promise(.success(result))
                }.store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
}

class StubOrganazationService: OrganazationServiceType {
    
    func createOrganazation(_ organazation: Organazation) -> AnyPublisher<CreateOrganazationModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getOrganazation() -> AnyPublisher<OrganazationModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func joinOrganazation(inviteCode: String) -> AnyPublisher<JoinOrganazationModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getDetailOrganazation(id: Int) -> AnyPublisher<OrganazationiDetailModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
    
    func getCalendar(id: Int) -> AnyPublisher<CalendarModel, any Error> {
        Empty().eraseToAnyPublisher()
    }
}
