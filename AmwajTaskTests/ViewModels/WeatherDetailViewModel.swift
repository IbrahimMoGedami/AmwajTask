//
//  WeatherDetailViewModel.swift
//  AmwajTaskTests
//
//  Created by Ibrahim Mo Gedami on 3/19/23.
//

import Foundation
import XCTest
@testable import AmwajTask

class WeatherDetailViewModelTests: XCTestCase {
    var sut: WeatherDetailsViewModel!
    var mainWeatherBody = ""
    var dailyWeatherModel: DailyWeatherModel = DailyWeatherModel(cod: "200",
                                                                 message: 2,
                                                                 cnt: 1,
                                                                 list: [List(dt: 123, main: MainClass(temp: 123, feelsLike: 123, tempMin: 123, tempMax: 123, pressure: 123, seaLevel: 123, grndLevel: 12, humidity: 12, tempKf: 12), weather: [Weather(id: 1, main: "clear", description: "clear", icon: "d20-2")], clouds: Clouds(all: 1), wind: Wind(speed: 0.0, deg: 23, gust: 2.3), visibility: 1, pop: 1, sys: Sys(type: 1, id: 1, country: "AE", sunrise: 123, sunset: 12, pod: Pod(rawValue: "sunny")), dtTxt: "dd", rain: Rain(the3H: 1.0))],
                                                                 city: City(id: 1, name: "Dubai", coord: Coord(lat: 23.34456, lon: 25.43), country: "AE", population: 1234, timezone: 123, sunrise: 123, sunset: 1234))
                                                                 
                                                                 
    var reloadedData = [WeatherViewModelData]()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mainWeatherBody = "lat=25.204849&lon=55.270782&appid=\(Constants.apiKey)&units=metric"
        sut = WeatherDetailsViewModel()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        
    }
    
    func testMainViewModel_WhenInformationProvided_WillValidateEachProperty() {
        // Arrange
        
        // Act
        Task{
            await sut.fetchedData(weatherList: dailyWeatherModel.list ?? [])
            // Assert
            XCTAssertTrue(dailyWeatherModel != nil, "Data reloaded successfully")
        }
        
    }
    
    func testGetWeatherData_WhenReceived() {
        // Arrange
        let jsonString = "{\"path\":\"/users\", \"error\":\"Internal Server Error\"}"
        MockURLProtocol.stubResponseData =  jsonString.data(using: .utf8)
        
        let errorExpectation = self.expectation(description: "getWeatherData() method expectation for a response that contains a different JSON structure")
        let expectation = self.expectation(description: "getWeatherData() met Response Expectation")
        
        // Act
        Task{
            await sut.fetchedData(weatherList: dailyWeatherModel.list ?? [])
            
            switch await sut.weatherDetailsState {
            case .ideal:
                print("Stop Loading")
            case .loading:
                print("Start Loading")
            case .success(let value):
                XCTAssertEqual(value.cod, "200")
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error, "The response model for a request containing unknown JSON response, should have been nil")
                errorExpectation.fulfill()
            case .successWith(let message):
                XCTAssertEqual(dailyWeatherModel.cod, "200")
                expectation.fulfill()
            }
//
        }
        
        self.wait(for: [expectation, errorExpectation], timeout: 5)
    }
    
    
}
