//
//  RequestReusable.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation
import Alamofire

protocol RequestReusable: Alamofire.URLRequestConvertible, AnyObject {
    var body: JsonEncadable? { get set }
    func addPathVariables(path: [String])
}

class Request: RequestReusable {
    
    init(url: RequestUrl, method: HTTPMethod, encoding: RequestEncodingType = .json) {
        self.urlReq = url
        self.method = method
        self.encoding = encoding
    }
    
    var body: JsonEncadable?
    private let urlReq: RequestUrl
    private let method: HTTPMethod
    private let encoding: RequestEncodingType
    
    private var pathVariables = ""
    
    func addPathVariables(path: [String]) {
        pathVariables = path.joined(separator: "/")
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlString = urlReq
            .value
            .appending(pathVariables)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: urlString)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // urlRequest.setValue(Constants.lang, forHTTPHeaderField: "lang")
        // urlRequest.setValue(Constants.os, forHTTPHeaderField: "ios")
        // urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        // urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        if let authorization = UserDefaults.userData?.token {
//            urlRequest.setValue("\(authorization)", forHTTPHeaderField: "Authorization")
//        }
        
        return try encoding.value.encode(urlRequest, with: body?.json)
    }
}
