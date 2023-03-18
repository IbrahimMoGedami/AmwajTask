//
//  SearchViewController.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import UIKit
import MapKit

protocol SearchPlacesViewProtocol: AnyObject {
    func didSelectRegion(locationName: String, lat: Double, lng: Double, streetName: String)
}

class SearchViewController: BaseController {
    
    @IBOutlet weak var searchResultsTable: UITableView!
    
    private var searchBar =  UISearchBar()
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchRegion: MKCoordinateRegion
    private var searchResults = [MKLocalSearchCompletion]()
    
    weak var delegate: SearchPlacesViewProtocol!
    var array = ["ddd","ddd", "ddd","ddd","ddd"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupViews(){
        searchBar.placeholder = "Search for a city"
        setupTableview()
    }
    
    
    init(delegate: SearchPlacesViewProtocol, region: MKCoordinateRegion = .init(.world)) {
        self.delegate = delegate
        self.searchRegion = region
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableview() {
        searchCompleter.delegate = self
        searchCompleter.region = searchRegion
        searchBar.delegate = self
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        searchResultsTable.rowHeight = 90
        searchResultsTable.tableFooterView = UIView()
        searchResultsTable.separatorStyle = .none
        navigationItem.titleView = searchBar
        searchResultsTable.register(cellType: LocationTableViewCell.self)
        searchResultsTable.keyboardDismissMode = .onDrag
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: LocationTableViewCell.self, for: indexPath)
        cell.titleLabel.text = searchResults[indexPath.row].title
        cell.descriptionLabel.text = searchResults[indexPath.row].subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self](response, error) in
            guard let self = self else {return}
            guard let coordinate = response?.mapItems[0].placemark.coordinate else { return }
            guard let name = response?.mapItems[0].name else {return}
            let lat = coordinate.latitude
            let lng = coordinate.longitude
            guard self.searchRegion.contains(coordinate) else {return}
            self.navigationController?.popViewController(animated: false)
            self.delegate.didSelectRegion(locationName: result.title, lat: lat, lng: lng, streetName: name)
        }
    }
}

extension SearchViewController: UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
//        showAlertController(title: MoreStrings.failed.message, message: error.validatorErrorAssociatedMessage.localized, selfDismissing: true, time: 0.5)
        print(error)
    }
}


