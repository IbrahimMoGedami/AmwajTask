//
//  JsonEncadable.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation

protocol JsonEncadable: Encodable {
    var json: [String: Any] { get }
}

extension JsonEncadable {
    var json: [String: Any] {
        let mirror = Mirror(reflecting: self)
        var dictEncoded = [String: Any]()
        mirror.children.forEach { child in
            dictEncoded[child.label!] = child.value
        }
        
        return dictEncoded
    }
}

struct EmptyJsonEncadable: JsonEncadable {
    
}
