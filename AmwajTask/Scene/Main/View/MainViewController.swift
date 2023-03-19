//
//  MainViewController.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import UIKit
import MapKit

class MainViewController: BaseController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    private let vm = MainViewModel()
    var data = [WeatherData]()
    var reloadedData = [WeatherViewModelData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchGestureRecognizer = BindableGestureRecognizer {
            self.searchViewTapped()
        }; searchView.addGestureRecognizer(searchGestureRecognizer)
        setupTableView()
        subscribe()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.backgroundImageView.addImageGradient()
        backgroundImageView.image = UIImage(named: "02n-2")
        self.backgroundImageAnimate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    
    private func backgroundImageAnimate() {
        self.backgroundImageView.frame.origin.x = 0
        UIView.animate(withDuration: 10, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.backgroundImageView.frame.origin.x -= 100
        }, completion: nil)
    }
    
    private func subscribe() {
        vm.$state
            .sink { state in
                self.handleState(state)
            }.store(in: &bag)
    }
    
    private func handleState(_ state: ScreenState<WeatherData>) {
        stopLoading()
        switch state {
        case .loading:
            startLoading()
        case .success(let value):
            setData(model: value)
        case .failure(let error):
            showAlert(with: error, title: .error)
        case .ideal:
            stopLoading()
        default:
            break
        }
    }
    
    private func setData(model: WeatherData){
        self.data.append(model)
        reloadedData = data.map({ WeatherViewModelData(model: $0)})
        if reloadedData.count == 3{
            tableView.reloadData()
        }
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.register(cellType: WeatherListTableViewCell.self)
    }
    
    @objc func searchViewTapped() {
        if reloadedData.count == 7 {
            showAlert(with: "Cities Count Should Be Between 3 OR 7", title: .warning)
        }else{
            if reloadedData.count < 3 {
                showAlert(with: "Cities Count Should Be More Than 3 To Displayed", title: .warning)
                let vc = SearchViewController(delegate: self)
                push(vc)
            }else{
                let vc = SearchViewController(delegate: self)
                push(vc)
            }
        }
        
    }
    
    @IBAction func getCurrentWeather(_ sender: UIButton) {
        let vc = WeatherDetailsViewController(lat: 0.0, lon: 0.0, dataState: .current)
        push(vc)
    }
    
}

extension MainViewController: SearchPlacesViewProtocol{
    func didSelectRegion(locationName: String, lat: Double, lng: Double, streetName: String) {
        var cities = [String]()
        cities.append(locationName)
        
        var citiesName = cities.joined(separator: ",")
        cityNameLabel.text = citiesName
        Task {
            await vm.getWeatherData(lat: lat, lng: lng)
        }
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reloadedData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: WeatherListTableViewCell.self, for: indexPath)
        cell.configCell(body: reloadedData[indexPath.row])
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(WeatherDetailsViewController(lat: reloadedData[indexPath.row].lat, lon: reloadedData[indexPath.row].lon, dataState: .selected))
    }
}


