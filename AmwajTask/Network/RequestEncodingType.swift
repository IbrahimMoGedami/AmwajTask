//
//  RequestEncodingType.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation
import Alamofire

enum RequestEncodingType {
    case json
    case url
    
    var value: ParameterEncoding {
        switch self {
        case .json:
           return JSONEncoding.default
        case .url:
            return URLEncoding.default
        }
    }
}
