//
//  WeatherListTableViewCell.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/16/23.
//

import UIKit

struct WeatherViewModelData {
    var cityName: String
    var minTemp: String
    var maxTemp: String
    var mainTemp: String
    var windSpeed: String
    var weatherDesc: String
    var lat: Double
    var lon: Double
    
    init(model: WeatherData) {
        self.cityName = model.name ?? ""
        self.minTemp = model.main?.min_temperatureString ?? ""
        self.maxTemp = model.main?.max_temperatureString ?? ""
        self.mainTemp = model.main?.temperatureString ?? ""
        self.windSpeed = (model.wind?.windSpeedString ?? "") + " " + (model.wind?.windDirection ?? "")
        self.weatherDesc = model.weather?[0].description ?? ""
        self.lat = model.coord?.lat ?? 0.0
        self.lon = model.coord?.lon ?? 0.0
    }
}

class WeatherListTableViewCell: UITableViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var minMaxTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code "°"
    }

    func configCell(body: WeatherViewModelData) {
        cityNameLabel.text = body.cityName
        minMaxTempLabel.text = "H: \(body.maxTemp)°  L: \(body.minTemp)°"
        windSpeedLabel.text = "\(body.windSpeed)"
        weatherDescLabel.text = body.weatherDesc
        mainTempLabel.text = "\(body.mainTemp )°"
    }
    
}
