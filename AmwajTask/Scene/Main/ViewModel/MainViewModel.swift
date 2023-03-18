//
//  MainViewModel.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/15/23.
//

import Foundation

class MainViewModel {
    
    @Published @MainActor var state: ScreenState<WeatherData> = .ideal
    let ds = HomeDataSource()
    var bag = AppBag()
    var weatherData: WeatherData?
    var weatherArrayData = [WeatherData]()
    var reloadedData: [WeatherViewModelData] {
        set {
            self.reloadedData = newValue
        }
        get {
            return self.reloadedData
        }
    }
    
    var getDataCount: Int {
        return weatherArrayData.count
    }
    
    func fillWeatherVM(data: [WeatherData]) -> [WeatherViewModelData] {
        let array = data.map({
            WeatherViewModelData(model: $0)
        })
        return array
    }
    
    @MainActor
    func getWeatherData(lat: Double, lng: Double) async {
        state = .loading
        async let networkState = ds.matchesRequest
            .addPathVariables(path: "lat=\(lat)&lon=\(lng)&appid=\(Constants.apiKey)")
            .makeRequest()
            .singleOutput(with: &bag)
        
        switch await networkState {
        case .success(let response):
            weatherData = response
            guard let weatherData else {return}
            state = .success(weatherData)
//            self.reloadedData = fillWeatherVM(data: weatherArrayData)
        case .fail(let error):
            state = .failure(error.errorDescription)
        }
    }
}
