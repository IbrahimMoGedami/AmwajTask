//
//  ScreenState.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation
import Combine

typealias ScreenPublisher<T: Codable> = AnyPublisher<NetworkState<T>, Never>

enum ScreenState<T>: Equatable {
    static func == (lhs: ScreenState<T>, rhs: ScreenState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.ideal, .ideal):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.successWith, .successWith):
            return true
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
    
    case ideal
    case loading
    case success(T)
    case failure(String)
    case successWith(message: String)
    
    var error: String? {
        switch self {
        case .failure(let value):
            return value
        default: return nil
        }
    }
    
    var data: T? {
        switch self {
        case .success(let value):
            return value
        default: return nil
        }
    }
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        } else {
            return false
        }
    }
}
