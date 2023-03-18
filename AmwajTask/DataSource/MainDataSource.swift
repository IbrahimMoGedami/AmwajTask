//
//  MainDataSource.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation

class MainDataSource: RequestMaker {
    
    @GET<WeatherData>(url: .path("/data/2.5/weather?"),encoding: .url)
    var network: any Network<WeatherData>
}

class HomeDataSource {
    init(
        matchesRequest: some RequestMaker<WeatherData> = MainDataSource()
    ) {
        self.matchesRequest = matchesRequest
    }
    
    let matchesRequest: any RequestMaker<WeatherData>
}

