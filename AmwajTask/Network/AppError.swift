//
//  AppError.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation

protocol AppError: LocalizedError {
    var errorDescription: String { get }
}

enum MyAppError: AppError {
    
    case networkError
    case businessError(String)
    
    public var errorDescription: String {
        switch self {
        case .networkError:
            return "networkError"
        case .businessError( let error):
            return error
        }
    }
}
