//
//  MockMainDataSource.swift
//  AmwajTaskTests
//
//  Created by Ibrahim Mo Gedami on 3/18/23.
//

import Foundation
@testable import AmwajTask

class MockMainDataSource: HomeDataSource {
    override init(matchesRequest: some RequestMaker = MainDataSource()) {
        super.init()
    }
}
