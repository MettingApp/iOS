//
//  Alamofire.swift
//  MettingApp
//
//  Created by 정성윤 on 11/23/24.
//

import Foundation
import Alamofire
import Combine
import SwiftKeychainWrapper

final class Alamofire {
    
    func loginAlamofire<T:Decodable>(url: String, params: [String:Any]) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"])
                .validate()
                .responseDecodable(of: T.self) { response in
//                    print(response.debugDescription)
                    switch response.result {
                    case let .success(result):
                        promise(.success(result))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func reissueRefresh<T:Decodable>(url: String, refresh: String) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            AF.request(url, method: .post, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "RefreshToken":refresh])
                .validate()
                .responseDecodable(of: T.self) { response in
//                    print(response.debugDescription)
                    switch response.result {
                    case let .success(data):
                        promise(.success(data))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func nonOfZeroPost(url: String, params: [String:Any]?) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            if let params = params {
                AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["content-Type":"application/json"], interceptor: TokenRequestInterceptor())
                    .validate()
                    .response { response in
//                        print(response.debugDescription)
                        switch response.result {
                        case .success:
                            if response.data?.isEmpty ?? true {
                                promise(.success(()))
                            } else {
                                promise(.success(()))
                            }
                        case let .failure(error):
                            promise(.failure(error))
                        }
                    }
            } else {
                AF.request(url, method: .post, encoding: JSONEncoding.default, headers: ["content-Type":"application/json"], interceptor: TokenRequestInterceptor())
                    .validate()
                    .response { response in
//                        print(response.debugDescription)
                        switch response.result {
                        case .success:
                            if response.data?.isEmpty ?? true {
                                promise(.success(()))
                            } else {
                                promise(.success(()))
                            }
                        case let .failure(error):
                            promise(.failure(error))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(url: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: ["content-Type":"application/json"], interceptor: TokenRequestInterceptor())
                .validate()
                .response { response in
//                    print(response.debugDescription)
                    switch response.result {
                    case .success:
                        if response.data?.isEmpty ?? true {
                            promise(.success(()))
                        } else {
                            promise(.success(()))
                        }
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func postAlamofire<T:Decodable>(url: String, params: [String:Any]?) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            if let params = params {
                AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["content-Type":"application/json"], interceptor: TokenRequestInterceptor())
                    .validate()
                    .responseDecodable(of: T.self) { response in
//                        print(response.debugDescription)
                        switch response.result {
                        case let .success(result):
                            promise(.success(result))
                        case let .failure(error):
                            promise(.failure(error))
                        }
                    }
            } else {
                AF.request(url, method: .post, encoding: JSONEncoding.default, headers: ["content-Type":"application/json"], interceptor: TokenRequestInterceptor())
                    .validate()
                    .responseDecodable(of: T.self) { response in
//                        print(response.debugDescription)
                        switch response.result {
                        case let .success(result):
                            promise(.success(result))
                        case let .failure(error):
                            promise(.failure(error))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
    func getAlamofire<T: Decodable>(url: String) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"], interceptor: TokenRequestInterceptor())
                .validate()
                .responseDecodable(of: T.self) { response in
                    print(response.debugDescription)
                    switch response.result {
                    case let .success(result):
                        promise(.success(result))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    func putAlamofire<T: Decodable>(url: String, params: [String:Any]) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"], interceptor: TokenRequestInterceptor())
                .validate()
                .responseDecodable(of: T.self) { response in
//                    print(response.debugDescription)
                    switch response.result {
                    case let .success(result):
                        promise(.success(result))
                    case let .failure(error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func multipartAlamofire<T: Decodable>(url: String, fileData: Data?, request: CreateMeetingRequest) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            AF.upload(multipartFormData: { multipartFormData in
                if let fileData = fileData {
                    multipartFormData.append(fileData, withName: "file", fileName: "file.wav", mimeType: "audio/wav")
                }
                do {
                    let jsonData = try JSONEncoder().encode(request)
                    multipartFormData.append(jsonData, withName: "req", mimeType: "application/json")
                } catch {
                    promise(.failure(error))
                    return
                }
            }, to: url, method: .post, headers: [
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VybmFtZUEiLCJyb2xlIjoiUk9MRV9VU0VSIiwiZXhwIjoxNzMyNjM3NTU4fQ.smjC6Um2RKjPSgtcdPRx-SWc9i7eVegC3mJ-T3WstsE"
            ])
            .validate()
            .responseDecodable(of: T.self) { response in
                print(response.debugDescription)
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
