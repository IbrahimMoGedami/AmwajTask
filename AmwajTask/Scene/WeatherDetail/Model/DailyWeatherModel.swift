//
//  DailyWeatherModel.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/17/23.
//

import Foundation

// MARK: - DailyWeatherModel
struct DailyWeatherModel: Codable {
    var cod: String?
    var message, cnt: Int?
    var list: [List]?
    var city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}


// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let sys: Sys?
    let dtTxt: String?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}


//// MARK: - DailyWeatherModel
//struct DailyWeatherModel: Codable {
//    let lat, lon: Double?
//    let timezone: String?
//    let timezoneOffset: Int?
//    let current: Current?
//    let hourly: [Current]?
//    let daily: [Daily]?
//
//    enum CodingKeys: String, CodingKey {
//        case lat, lon, timezone
//        case timezoneOffset = "timezone_offset"
//        case current, hourly, daily
//    }
//}
//
//// MARK: - Current
//struct Current: Codable {
//    let sunrise, sunset: Int?
//    let temp, feelsLike, dt: Double?
//    let pressure, humidity: Int?
//    let dewPoint, uvi: Double?
//    let clouds, visibility: Int?
//    let windSpeed: Double?
//    let windDeg: Int?
//    let windGust: Double?
//    let weather: [Weather]?
//    let pop: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case dt, sunrise, sunset, temp
//        case feelsLike = "feels_like"
//        case pressure, humidity
//        case dewPoint = "dew_point"
//        case uvi, clouds, visibility
//        case windSpeed = "wind_speed"
//        case windDeg = "wind_deg"
//        case windGust = "wind_gust"
//        case weather, pop
//    }
//}
//
//// MARK: - Daily
//struct Daily: Codable {
//    let sunrise, sunset, moonrise: Int?
//    let moonset: Int?
//    let moonPhase, dt: Double?
//    let temp: Temp?
//    let feelsLike: FeelsLike?
//    let pressure, humidity: Int?
//    let dewPoint, windSpeed: Double?
//    let windDeg: Int?
//    let windGust: Double?
//    let weather: [Weather]?
//    let clouds: Int?
//    let pop, uvi, rain: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case dt, sunrise, sunset, moonrise, moonset
//        case moonPhase = "moon_phase"
//        case temp
//        case feelsLike = "feels_like"
//        case pressure, humidity
//        case dewPoint = "dew_point"
//        case windSpeed = "wind_speed"
//        case windDeg = "wind_deg"
//        case windGust = "wind_gust"
//        case weather, clouds, pop, uvi, rain
//    }
//}
//
//// MARK: - FeelsLike
//struct FeelsLike: Codable {
//    let day, night, eve, morn: Double?
//}
//
//// MARK: - Temp
//struct Temp: Codable {
//    let day, min, max, night: Double?
//    let eve, morn: Double?
//}
