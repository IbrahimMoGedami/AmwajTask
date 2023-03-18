//
//  LocationMaster.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import Foundation
import CoreLocation
import Combine

struct LocationMasterAddressModel {
    let address, streetName: String
}

protocol LocationMasterDelegate: AnyObject {
    func current(speed: Double)
    func centerMapOnUserLocation()
    func locationUpdated(location: CLLocation)
    func showAlertPermission()
}

extension LocationMasterDelegate {
    func current(speed: Double) { }
    func centerMapOnUserLocation() { }
    func locationUpdated(location: CLLocationCoordinate2D?) { }
    func showAlertPermission(){}
}

class LocationMaster: NSObject, CLLocationManagerDelegate {
    
    weak var delegate: LocationMasterDelegate?
    private(set) var locationManger = CLLocationManager()
//    private var authorizationStatus = CLLocationManager.authorizationStatus()
    
    var isLocationEnabled: Bool {
        return locationManger.location != nil
    }
    
    var userLongitude: Double {
        return locationManger.location?.coordinate.longitude ?? 0.0
    }
    
    var userLatitude: Double {
        return locationManger.location?.coordinate.latitude ?? 0.0
    }
    
    var userLocation: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude)
    }
    
    static func getAddressOfLocation(lat: Double?, lng: Double?, complition: @escaping (String?, String?) -> ()) {
        guard let _lat = lat, let _lng = lng else {return}
        let location = CLLocation(latitude: _lat, longitude: _lng)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print(error ?? "Unknown Error")
            } else {
                
                guard let placemark = placemarks?.first else {return}
                let streetName = placemark.thoroughfare ?? ""
                let area = placemark.administrativeArea ?? ""
                let locality =  placemark.locality ?? ""
                let address = (streetName + " " + locality + " "  + area)
                complition(address, streetName)
            }
        }
    }
    
    static func getAddressOfLocation(lat: Double?, lng: Double?) -> AnyPublisher<LocationMasterAddressModel, Never> {
        Future<LocationMasterAddressModel, Never> { promise in
            guard let _lat = lat, let _lng = lng else {return}
            let location = CLLocation(latitude: _lat, longitude: _lng)
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    print(error ?? "Unknown Error")
                } else {
                    guard let placemark = placemarks?.first else { return }
                    let streetName = placemark.thoroughfare ?? ""
                    let area = placemark.administrativeArea ?? ""
                    let locality =  placemark.locality ?? ""
                    let address = (streetName + " " + locality + " " + area)
                    promise(.success(.init(address: address, streetName: streetName)))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    init(delegate: LocationMasterDelegate? = nil) {
        super.init()
        self.delegate = delegate
        locationManger.delegate = self
    }
    
    func checkAuthorizationStatus() {
        let authorizationStatus = locationManger.authorizationStatus
        
        if authorizationStatus == .notDetermined || authorizationStatus == .restricted {
            locationManger.requestAlwaysAuthorization()
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            locationManger.requestWhenInUseAuthorization()
            // locationManger.allowsBackgroundLocationUpdates = true
            locationManger.showsBackgroundLocationIndicator = true
            locationManger.startUpdatingLocation()
        } else {
            locationManger.startUpdatingLocation()
            //             delegate?.showAlertPermison()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        delegate?.locationUpdated(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.centerMapOnUserLocation()
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

// MARK: - Welcome
struct LocationFetchModel: Codable {
    let plusCode: PlusCode?
    let results: [ResultModel]?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case plusCode = "plus_code"
        case results, status
    }
}

// MARK: - PlusCode
struct PlusCode: Codable {
    let compoundCode, globalCode: String?
    
    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

// MARK: - Result
struct ResultModel: Codable {
    let addressComponents: [AddressComponent]?
    let formattedAddress: String?
    let geometry: GeometryModel?
    let placeID: String?
    let plusCode: PlusCode?
    let types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeID = "place_id"
        case plusCode = "plus_code"
        case types
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let longName, shortName: String?
    let types: [String]?
    
    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

// MARK: - Geometry
struct GeometryModel: Codable {
    let location: LocationModle?
    let locationType: String?
    let viewport, bounds: Bounds?
    
    enum CodingKeys: String, CodingKey {
        case location
        case locationType = "location_type"
        case viewport, bounds
    }
}

// MARK: - Bounds
struct Bounds: Codable {
    let northeast, southwest: LocationModle?
}

// MARK: - Location
struct LocationModle: Codable {
    let lat, lng: Double?
}
