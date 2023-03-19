//
//  MainViewModel.swift
//  AmwajTaskTests
//
//  Created by Ibrahim Mo Gedami on 3/19/23.
//

import Foundation
import XCTest
@testable import AmwajTask

class MainViewModelTests: XCTestCase {
    var sut: MainViewModel!
    @Published @MainActor var state: ScreenState<WeatherData> = .ideal
    let ds = HomeDataSource()
    var bag = AppBag()
    var mainWeatherBody = ""
    var weatherData: WeatherData = WeatherData(coord: Coord(lat: 0.0, lon: 0.0), weather: [Weather(id: 0, main: "clear", description: "sunny", icon: "1-dd")], base: "clear", main: Main(temp: 0.0, feelsLike: 0.0, tempMin: 0.0, tempMax: 0.0, pressure: 0.0, humidity: 0.0), visibility: 1, wind: Wind(speed: 0.0, deg: 23, gust: 2.3), clouds: Clouds(all: 1), dt: 12223.0, sys: Sys(type: 1, id: 1, country: "AE", sunrise: 12341, sunset: 342, pod: Pod(rawValue: "sunny")), timezone: 12342, id: 12332, name: "Dubai", cod: 200)
    var reloadedData = [WeatherViewModelData]()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mainWeatherBody = "lat=25.204849&lon=55.270782&appid=\(Constants.apiKey)"
        sut = MainViewModel()
        //        mockValidator = MockValidator()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        
    }
    
    func testMainViewModel_WhenInformationProvided_WillValidateEachProperty() {
        // Arrange
        
        // Act
        Task{
            await sut.getWeatherData(lat: 25.204849, lng: 55.270782)
        }
        
        // Assert
        XCTAssertTrue(reloadedData.count == 3, "Data reloaded successfully")
        
    }
    
    func testGetWeatherData_WhenReceived() {
        // Arrange
        let jsonString = "{\"path\":\"/users\", \"error\":\"Internal Server Error\"}"
        MockURLProtocol.stubResponseData =  jsonString.data(using: .utf8)
        
        let errorExpectation = self.expectation(description: "getWeatherData() method expectation for a response that contains a different JSON structure")
        let expectation = self.expectation(description: "getWeatherData() met Response Expectation")
        
        // Act
        Task{
            await sut.getWeatherData(lat: 25.204849, lng: 55.270782)
            
            switch await sut.state {
            case .loading:
                print("Start Loading")
            case .success(let value):
                XCTAssertEqual(value.cod, 200)
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error, "The response model for a request containing unknown JSON response, should have been nil")
                errorExpectation.fulfill()
            case .ideal:
                print("Stop Loading")
            default:
                break
            }
            
        }
        
        self.wait(for: [expectation, errorExpectation], timeout: 5)
    }
    
    
}
