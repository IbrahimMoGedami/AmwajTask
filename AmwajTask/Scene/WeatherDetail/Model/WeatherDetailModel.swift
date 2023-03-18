//
//  WeatherDetailModel.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/17/23.
//

import Foundation

// MARK: - WeatherDetailModel
struct WeatherDetailModel: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
}


// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

