//
//  MakeRequest.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation

protocol RequestMaker<T>: AnyObject {
    
    associatedtype T: Codable
    func addPathVariables(path: String...) -> Self
    var network: any Network<T> { get }
    func makeRequest() -> RequestPublisher<T>
}

extension RequestMaker {
    func makeRequest() -> RequestPublisher<T> {
        network
            .asPublisher()
            .eraseToAnyPublisher()
    }
    
    func addPathVariables(path: String...) -> Self {
        network.request.addPathVariables(path: path)
        return self
    }
}
