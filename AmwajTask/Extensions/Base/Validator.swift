//
//  Validator.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/18/23.
//

import Foundation

class Validator {
    
    @discardableResult
    static func validateCitySearch(with text: String?) throws -> String {
        if let text = text {
            if text.isEmpty {
                throw UserAuthenticationError.emptyText
            }else if calcCities(text) == false{
                throw UserAuthenticationError.inValidSearch
            } else {
                return text
            }
        }else {
            throw UserAuthenticationError.emptyText
        }
    }
    
    static func calcCities(_ text: String) -> Bool {
        let subjectArray = text.components(separatedBy:",")
        if subjectArray.count >= 3 || subjectArray.count <= 7 {
            return true
        }else{
            return false
        }
    }
    enum UserAuthenticationError: AppError {
        
        case emptyText
        case inValidSearch
       
        
        var errorDescription: String {
            var message = "Error"
            
            switch self {
            case .emptyText:
                message = "Please, Enter Your City First."
            case .inValidSearch:
                message = "Cities Count Should Be Between 3 OR 7"
            }
            
            return message
        }
    }
}
