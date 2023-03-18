//
//  RequestMethod.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation
import Alamofire
import SwiftUI

@propertyWrapper
struct GET<T: Codable> {
    
    var wrappedValue: any Network<T> {
        mutating get {
            return request
        }
    }
    
    private var request: any Network<T>
    
    init(url: RequestUrl, encoding: RequestEncodingType = .json) {
        request = AsyncRequest<T>(request: Request(url: url, method: .get, encoding: encoding))
    }
}
