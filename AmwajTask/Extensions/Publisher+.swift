//
//  Publisher+.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/16/23.
//

import Foundation
import Combine

extension Publishers {
    struct MissingOutputError: Error {}
}

extension Publisher {
    func singleOutput() async throws -> Output {
        var cancellable: AnyCancellable?
        var didReceiveValue = false
        
        return try await withCheckedThrowingContinuation { continuation in
            cancellable = sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        if !didReceiveValue {
                            continuation.resume(
                                throwing: Publishers.MissingOutputError()
                            )
                        }
                    }
                },
                receiveValue: { value in
                    guard !didReceiveValue else { return }
                    
                    didReceiveValue = true
                    cancellable?.cancel()
                    continuation.resume(returning: value)
                }
            )
        }
    }
}

extension Publisher where Failure == MyAppError {
    func singleOutput(comp : @escaping ((_ U: Output) -> ())) {
        var cancellable: AnyCancellable?
        var didReceiveValue = false
        cancellable = sink(
            receiveCompletion: { completion in },
            receiveValue: { value in
                guard !didReceiveValue else { return }
                comp(value)
                didReceiveValue = true
                cancellable?.cancel()
            }
        )
    }
}


extension Publisher where Failure == Never {
  func singleOutput( with bag: inout AppBag) async -> Output {
    return await withCheckedContinuation { continuation in
      sink(receiveValue: { value in
        //          guard !didReceiveValue else { return }
        //          didReceiveValue = true
        //          cancellable?.cancel()
        continuation.resume(returning: value)
      }).store(in: &bag)
    }
  }
}
