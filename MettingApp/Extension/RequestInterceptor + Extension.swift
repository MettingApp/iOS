//
//  RequestInterceptor + Extension.swift
//  UnivApp
//
//  Created by 정성윤 on 9/20/24.
//

import Foundation
import Alamofire
import Combine
import SwiftKeychainWrapper
import SwiftUI

final class TokenRequestInterceptor: RequestInterceptor {
    private var subscriptions = Set<AnyCancellable>()

    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
//        if let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken") {
//            if urlRequest.headers["Authorization"] == nil {
//                urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
//            }
//        } else {
//            print("액세스 토큰 없음")
//        }
        if urlRequest.headers["Authorization"] == nil {
            urlRequest.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VybmFtZUEiLCJyb2xlIjoiUk9MRV9VU0VSIiwiZXhwIjoxNzMyNDQyNjk0fQ.COn2wgRO2A6FnKkVcS1HYL0Rja4b98_aU9eE_layztw", forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }

    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: Error,
                      completion: @escaping (RetryResult) -> Void) {
        let retryLimit = 2
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return completion(.doNotRetryWithError(error))
        }
            
        guard request.retryCount < retryLimit else { return completion(.doNotRetryWithError(error)) }
        Task {
            guard let refreshToken = KeychainWrapper.standard.string(forKey: "JWTrefreshToken") else {
                return completion(.doNotRetryWithError(error))
            }
            Alamofire().reissueRefresh(url: APIEndpoint.refresh.urlString, refresh: refreshToken)
                .sink { completionStatus in
                    switch completionStatus {
                    case .finished:
                        print("토큰 재발행 성공")
                    case let .failure(error):
                        print("토큰 재발행 실패 \(error)")
                        KeychainWrapper.standard.removeAllKeys()
                        return completion(.doNotRetryWithError(error))
                    }
                } receiveValue: { (response: UserModel) in
                    KeychainWrapper.standard.removeAllKeys()
                    print("토큰 재발행 성공")
                    KeychainWrapper.standard.set("Bearer \(response.accessToken)", forKey: "JWTaccessToken")
                    KeychainWrapper.standard.set(response.refreshToken, forKey: "JWTrefreshToken")
                    return completion(.retry)
                }.store(in: &subscriptions)
        }
    }
}
