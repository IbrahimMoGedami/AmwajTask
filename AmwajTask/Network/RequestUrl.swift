//
//  RequestUrl.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation

enum RequestUrl {
    case full(String)
    case path(String)
    
    var value: String {
        
        let baseUrl = Constants.weatherUrl//Constants.baseUrl
        
        switch self {
        case .full(let url):
            return url
            
        case.path(let path):
            return baseUrl + path
        }
    }
}
