//
//  AsyncRequest.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation
import Alamofire
import Combine

typealias RequestPublisher<T: Codable> = AnyPublisher<NetworkState<T>, Never>

protocol Network<T>: AnyObject {
    associatedtype T: Codable
    var request: RequestReusable { get }
    func asPublisher() -> RequestPublisher<T>
}

class AsyncRequest<T: Codable>: Network {
    
    var request: RequestReusable
    
    private lazy var interceptor = AppRequestInterceptor()
    
    init(request: RequestReusable) {
        self.request = request
    }
    
    private lazy var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest = 60
        return Session(configuration: configuration, interceptor: interceptor)
    }()
    
    fileprivate func handle(_ response: DataResponsePublisher<AsyncRequest<T>.DecodingModel>.Output) -> NetworkState<T> {
        switch response.result {
        case .success(let model):
            let state = NetworkState<T>(model)
            return state
        case .failure(let error):
            debugPrint("Model Name: \(String(describing: T.self)) has request error", error)
            return .fail(MyAppError.networkError)
        }
    }
    
    @discardableResult
    func asPublisher() -> RequestPublisher<T> {
        sessionManager
            .request(request)
            .publishDecodable(type: DecodingModel.self, queue: .global())
            .map({[weak self] response in
                guard let self else {
                    return .fail(MyAppError.networkError)
                }
                return self.handle(response)
            })
            .eraseToAnyPublisher()
        
    }
    
    typealias DecodingModel = T
}
