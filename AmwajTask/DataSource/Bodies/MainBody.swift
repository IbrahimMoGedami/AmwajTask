//
//  MainBody.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation
import Alamofire

struct MainWeatherBopdy: JsonEncadable {
    var lat: Double?
    var lon: Double?
    var appid: String?
}
