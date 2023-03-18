//
//  UnknownType.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation

enum UnknownType<F: Codable, S: Codable>: Codable {
    
    case firstValue(F)
    case secoundValue(S)
    
    var value: String? {
        switch self {
            case .firstValue(let val):
                return getValue(val)
            case .secoundValue(let val):
                return getValue(val)
        }
    }
    
    func getValue<T>(of type: T.Type) -> T? {
        switch self {
        case .firstValue(let val):
            return val as? T
        case .secoundValue(let val):
            return val as? T
        }
    }
    
    private func getValue(_ val: Any) -> String? {
        if let stringValue = val as? String {
            return stringValue
        } else if let intValue = val as? Int {
            return "\(intValue)"
        } else if val is Swift.Array<Swift.String> {
            let firstValue = (val as? [Any])?.first
            return "\(firstValue ?? "Error Found")"
        } else {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(F.self) {
            self = .firstValue(value)
            return
        }
        if let value = try? container.decode(S.self) {
            self = .secoundValue(value)
            return
        }
        throw DecodingError.typeMismatch(UnknownType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ID"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .secoundValue(let x):
                try container.encode(x)
            case .firstValue(let x):
                try container.encode(x)
        }
    }
}
