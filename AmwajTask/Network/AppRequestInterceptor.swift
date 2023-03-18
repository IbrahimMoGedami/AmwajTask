//
//  AppRequestInterceptor.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation
import Alamofire

class AppRequestInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("6aafc784357c4532a683096c59c52e4e", forHTTPHeaderField: "X-Auth-Token")
        completion(.success(urlRequest))
    }
}

//Bearer
