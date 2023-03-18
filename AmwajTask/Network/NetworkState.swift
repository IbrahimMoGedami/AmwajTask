//
//  NetworkState.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation

enum NetworkState<R: Codable> {
    case success(R)
    case fail(AppError)
    
    var data: R? {
        switch self {
        case .success(let data):
            return data
        default:
            return nil
        }
    }
    
    var error: AppError? {
        switch self {
        case .fail(let error):
            return error
        default:
            return nil
        }
    }
    
    init(_ response: R?) {
        if let response {
            self = .success(response)
        } else {
            self = .fail(MyAppError.networkError)
        }
    }
}
