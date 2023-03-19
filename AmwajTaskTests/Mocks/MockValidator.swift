//
//  MockValidator.swift
//  AmwajTaskTests
//
//  Created by Ibrahim Mo Gedami on 3/19/23.
//


import Foundation
@testable import AmwajTask

class MockValidator: Validator {
    var isCityValidated: Bool = false
    
    func validateCitySearch(with text: String?) throws -> String {
        isCityValidated = true
        guard calcCities(text ?? "") else {throw Validator.UserAuthenticationError.inValidSearch}
        return text ?? ""
    }
    

    func calcCities(_ text: String) -> Bool {
        isCityValidated = true
        return isCityValidated
    }
}
