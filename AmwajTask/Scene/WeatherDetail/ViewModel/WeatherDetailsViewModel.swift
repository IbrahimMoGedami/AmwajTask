//
//  WeatherDetailsViewModel.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/17/23.
//

import Foundation

class WeatherDetailsViewModel {
    
    @Published @MainActor var weatherDetailsState: ScreenState<DailyWeatherModel> = .ideal
    @Published @MainActor var currentState: ScreenState<WeatherData> = .ideal
    
    let ds = DetailsDataSource()
    let homeDS = HomeDataSource()
    var bag = AppBag()
    var baseData: DailyWeatherModel?
    private var cellViewModels: [[WeatherListCellViewModel]] = [[WeatherListCellViewModel]]()
    
    
    @MainActor
    func getCurrentData(lat: Double, lng: Double) async {
        currentState = .loading
        async let networkState = homeDS.matchesRequest
            .addPathVariables(path: "lat=\(lat)&lon=\(lng)&appid=\(Constants.apiKey)")
            .makeRequest()
            .singleOutput(with: &bag)

        switch await networkState {
        case .success(let response):
            currentState = .success(response)
            print(response)
        case .fail(let error):
            currentState = .failure(error.errorDescription)
        }
    }
    
    @MainActor
    func getWeatherDetailsData(lat: Double, lng: Double) async {
        weatherDetailsState = .loading
        async let networkState = ds.dailyRequest
            .addPathVariables(path: "lat=\(lat)&lon=\(lng)&appid=\(Constants.apiKey)&units=metric")
            .makeRequest()
            .singleOutput(with: &bag)
        
        switch await networkState {
        case .success(let response):
            weatherDetailsState = .success(response)
            self.baseData = response
            print(response)
        case .fail(let error):
            weatherDetailsState = .failure(error.errorDescription)
        }
    }
    
    
}

extension WeatherDetailsViewModel {
    
    // City details
    func getCityViewModel() -> City {
        return self.baseData?.city ?? City(id: 792680,
                                               name: "Dubai",
                                               coord: nil,
                                               country: "AE",
                                               population: 1273651,
                                               timezone: 7200,
                                               sunrise: 1653102236,
                                               sunset: 1653156348)
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    // Adding data in new weather list model
    func createCellViewModel( weather: List ) -> WeatherListCellViewModel {
        let weatherDate = DateHelper.convertDateFromTimestamp(timeStamp: weather.dt)
        return WeatherListCellViewModel(weatherDate: weatherDate,
                                        dt: weather.dt ?? 0,
                                        main: weather.main,
                                        weather: weather.weather,
                                        clouds: weather.clouds,
                                        wind: weather.wind,
                                        visibility: weather.visibility,
                                        pop: weather.pop,
                                        sys: weather.sys,
                                        dtTxt: weather.dtTxt,
                                        rain: weather.rain)
    }
    
    //    selected section data
        func getCellViewModel( at indexPath: IndexPath ) -> [WeatherListCellViewModel] {
               return cellViewModels[indexPath.item]
        }
       
    // Bind api responce in model
    func fetchedData( weatherList: [List] ) {
        self.baseData?.list = weatherList
        var vms = [WeatherListCellViewModel]()
        for weather in weatherList {
            vms.append( createCellViewModel(weather: weather) )
        }
        
        let groupWeatherList = Dictionary(grouping: vms, by: {$0.weatherDate})
            .values
            .sorted(by: { $0[0].dt < $1[0].dt })
        
        self.cellViewModels = groupWeatherList
    }
}

struct WeatherListCellViewModel: Equatable {
    static func == (lhs: WeatherListCellViewModel, rhs: WeatherListCellViewModel) -> Bool {
       return lhs.weatherDate == rhs.weatherDate
    }
    
    let weatherDate: Date
    let dt: Int
    let main: MainClass?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let sys: Sys?
    let dtTxt: String?
    let rain: Rain?
}
