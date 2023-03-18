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
    
    private let vm = MainViewModel()
    var data = [WeatherData]()
    var reloadedData = [WeatherViewModelData]()
    private var searchBar =  UISearchBar()
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchRegion = MKCoordinateRegion.init(.world)
    private var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchGestureRecognizer = BindableGestureRecognizer {
            self.searchViewTapped()
        }; searchView.addGestureRecognizer(searchGestureRecognizer)
        setupTableView()
        searchBar.placeholder = "Search for a city"
        searchRegion = MKCoordinateRegion.init(.world)
        searchCompleter.delegate = self
        searchCompleter.region = searchRegion
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        subscribe()
    }

    func getCityList(results: [MKLocalSearchCompletion]) -> [(city: String, country: String)]{
        
        var searchResults: [(city: String, country: String)] = []
        
        for result in results {
            
            let titleComponents = result.title.components(separatedBy: ", ")
            let subtitleComponents = result.subtitle.components(separatedBy: ", ")
            
            buildCityTypeA(titleComponents, subtitleComponents){place in
                
                if place.city != "" && place.country != ""{
                    
                    searchResults.append(place)
                }
            }
            
            buildCityTypeB(titleComponents, subtitleComponents){place in
                
                if place.city != "" && place.country != ""{
                    
                    searchResults.append(place)
                }
            }
        }
        
        return searchResults
    }
    
    func buildCityTypeA(_ title: [String],_ subtitle: [String], _ completion: @escaping ((city: String, country: String)) -> Void){
        
        var city: String = ""
        var country: String = ""
        
        if title.count > 1 && subtitle.count >= 1 {
            
            city = title.first!
            country = subtitle.count == 1 && subtitle[0] != "" ? subtitle.first! : title.last!
        }
        
        completion((city, country))
    }

    func buildCityTypeB(_ title: [String],_ subtitle: [String], _ completion: @escaping ((city: String, country: String)) -> Void){
        
        var city: String = ""
        var country: String = ""
        
        if title.count >= 1 && subtitle.count == 1 {
            
            city = title.first!
            country = subtitle.last!
        }
        
        completion((city, country))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
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
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 150
        tableView.register(cellType: WeatherListTableViewCell.self)
    }
    
    @objc func searchViewTapped() {
        let vc = SearchViewController(delegate: self)
        push(vc)
    }
    
    @IBAction func getCurrentWeather(_ sender: UIButton) {
        let vc = WeatherDetailsViewController(lat: 0.0, lon: 0.0, dataState: .current)
        push(vc)
    }
    
}

extension MainViewController: SearchPlacesViewProtocol{
    func didSelectRegion(locationName: String, lat: Double, lng: Double, streetName: String) {
        cityNameLabel.text = locationName
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

extension MainViewController: UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        print(self.getCityList(results: completer.results))
//        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
//        showAlertController(title: MoreStrings.failed.message, message: error.validatorErrorAssociatedMessage.localized, selfDismissing: true, time: 0.5)
        print(error)
    }
}


