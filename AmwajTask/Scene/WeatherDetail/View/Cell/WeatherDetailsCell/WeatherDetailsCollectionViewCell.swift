//
//  WeatherDetailsCollectionViewCell.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/18/23.
//

import UIKit

class WeatherDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    
    var weatherList: [WeatherListCellViewModel]?
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: DailyWeatherTableViewCell.self)
        tableView.reloadData()
    }
}
 
    // MARK: - Table View
extension WeatherDetailsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // Header Title
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let date = weatherList?[section].weatherDate
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 0, width: headerView.frame.width-10, height: headerView.frame.height)
        label.text = DateHelper.getDateString(date: date ?? Date()) // set Date on current section
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        headerView.addSubview(label)
        headerView.backgroundColor = .clear
        return headerView
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: DailyWeatherTableViewCell.self, for: indexPath)
        if let weather = weatherList?[indexPath.row] {
            // Set time
            cell.timeLabel.text = DateHelper.convertTimeFromTimestamp(timeStamp: weather.dt)
            // Set temperature
            let temp = round(weather.main?.temp ?? 0)
            cell.tempLabel.text = "\(Int(temp))°C"
            // Set weather icon
            let imgName = weather.weather?.first?.icon ?? "01d"
//            cell.imgView.(with: URL(string: "https://openweathermap.org/img/wn/\(imgName)@2x.png"))
        }
        return cell
    }
}
