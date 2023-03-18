//
//  DetailsDataSource.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/17/23.
//

import Foundation

class DailyDataSource: RequestMaker {

    @GET<DailyWeatherModel>(url: .path("/data/2.5/forecast?"),encoding: .url)
    var network: any Network<DailyWeatherModel>
}

class DetailsDataSource {
    init(
        dailyRequest: some RequestMaker<DailyWeatherModel> = DailyDataSource()
    ) {
        self.dailyRequest = dailyRequest
    }
    
    let dailyRequest: any RequestMaker<DailyWeatherModel>
}
