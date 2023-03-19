//
//  WeatherDetailsViewController.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/16/23.
//

import UIKit
import CoreLocation

enum CurrentOrSelectedData {
    case current
    case selected
}

class WeatherDetailsViewController: BaseController {
    
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var vm = WeatherDetailsViewModel()
    var lat: Double
    var lon: Double
    var dataState: CurrentOrSelectedData
    
    private lazy var locationMaster = LocationMaster(delegate: self)
    private var currentLocation: CLLocation?
    var currentWeather: WeatherData?
    var dailyWeather: DailyWeatherModel?
    
    init(lat: Double, lon: Double, dataState: CurrentOrSelectedData) {
        self.lat = lat
        self.lon = lon
        self.dataState = dataState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        subscribe()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationMaster.checkAuthorizationStatus()
        
        Task {
            switch dataState {
            case .current:
                await vm.getWeatherDetailsData(lat: lat, lng: lon)
            case .selected:
                await vm.getWeatherDetailsData(lat: currentLocation?.coordinate.latitude ?? 0.0, lng: currentLocation?.coordinate.longitude ?? 0.0)
            }
            
        }
        
        pageController.currentPage = 0
        pageController.translatesAutoresizingMaskIntoConstraints = false
        pageController.currentPageIndicatorTintColor = .white
        pageController.pageIndicatorTintColor = .darkGray
    }
    
    func setupCollectionView() {
        collectionView.register(cellType: WeatherDetailsCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    private func subscribe() {
        vm.$weatherDetailsState
            .sink { [weak self] state in
                guard let self else {return}
                self.handleDailyWeatherState(state)
            }.store(in: &bag)
  
    }
    
    private func handleDailyWeatherState(_ state: ScreenState<DailyWeatherModel>) {
        stopLoading()
        switch state {
        case .loading:
            startLoading()
        case .success(let value):
            self.dailyWeather = value
            vm.fetchedData(weatherList: value.list ?? [])
            setData(value)
            collectionView.reloadData()
            
        case .failure(let error):
            showAlert(with: error, title: .error)
        case .ideal:
            stopLoading()
        default:
            break
        }
    }
    
    
    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            let page: Int = sender.currentPage
            let indexPath = IndexPath(item: page, section: 0)
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        })
    }
    
    func setData(_ data: DailyWeatherModel) {
        
        pageController.numberOfPages = vm.numberOfCells
       
        switch dataState {
        case .current:
            LocationMaster.getAddressOfLocation(lat: currentLocation?.coordinate.latitude ?? 0.0, lng: currentLocation?.coordinate.longitude ?? 0.0, complition: { address, streetName in
                 self.cityNameLabel.text = address
            })
        case .selected:
            LocationMaster.getAddressOfLocation(lat: lat, lng: lon, complition: { address, streetName in
                 self.cityNameLabel.text = address
            })
        }
        
    }
}

extension WeatherDetailsViewController: LocationMasterDelegate {
    func locationUpdated(location: CLLocation) {
        currentLocation = location
        print(location)
        
        locationMaster.locationManger.stopUpdatingLocation()
    }
    
    func showAlertPermission() {
        alertPermission()
    }
}

extension WeatherDetailsViewController {
    
    private func updateUI() {
        // Page Control
        pageController.addTarget(self, action: #selector(pageControlSelectionAction), for: [.touchUpInside, .touchCancel, .touchDragExit])
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.backgroundImageView.addImageGradient()
        self.backgroundImageView.image = UIImage(named: "02n-2")
        self.backgroundImageAnimate()
    }
    
    
    private func backgroundImageAnimate() {
        self.backgroundImageView.frame.origin.x = 0
        UIView.animate(withDuration: 10, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.backgroundImageView.frame.origin.x -= 100
        }, completion: nil)
    }
    
}

extension WeatherDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: WeatherDetailsCollectionViewCell.self, for: indexPath)
        let cellDataVM = vm.getCellViewModel(at: indexPath)
        cell.weatherList = cellDataVM
        cell.setupTableView()
        return cell
    }
}


// MARK: - CollectionView Layout

extension WeatherDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.screenWidth, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0.0001
    }
}

// MARK: - PageControl update
extension WeatherDetailsViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / view.frame.width
        pageController.currentPage = Int(scrollPos)
    }
}


