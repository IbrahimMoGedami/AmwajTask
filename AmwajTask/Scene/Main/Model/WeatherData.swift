//
//  WeatherData.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/15/23.
//

import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Double?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temp)
    }
    
    var min_temperatureString: String {
        return String(format: "%.1f", tempMin)
    }
    
    var max_temperatureString: String {
        return String(format: "%.1f", tempMax)
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
    let pod: Pod?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
    
    var windSpeedString: String {
        return String(format: "%.1f", speed)
    }
    
    var windDirection: String {
        switch deg {
        case 0:
            return "North"
        case 1...89:
            return "NE"
        case 90:
            return "East"
        case 91...179:
            return "SE"
        case 180:
            return "South"
        case 181...269:
            return "SW"
        case 270:
            return "West"
        case 271...359:
            return "NW"
        default:
            return "North"
        }
    }
}
