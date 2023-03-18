//
//  Maps+.swift
//  AmwajTask
//
//  Created by Ibrahim Mo Gedami on 3/14/23.
//

import UIKit
import MapKit

extension MKCoordinateRegion {
    /// confirms that a region contains a location
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let deltaLat = abs((self.center.latitude - coordinate.latitude).wrapped(dimension: .latitude))
        let deltaLng = abs((self.center.longitude - coordinate.longitude).wrapped(dimension: .longitude))
        return self.span.latitudeDelta/2.0 >= deltaLat && self.span.longitudeDelta/2.0 >= deltaLng
    }
}

extension CLLocationDegrees {

    enum WrappingDimension: Double {
        case latitude = 180
        case longitude = 360
    }

    /// Standardizes and angle to [-180 to 180] or [-90 to 90] degrees
    func wrapped(dimension: WrappingDimension) -> CLLocationDegrees {
        let length = dimension.rawValue
        let halfLength = length/2.0
        let angle = self.truncatingRemainder(dividingBy: length)
        switch dimension {
        case .longitude:
            //        return angle < -180.0 ? 360.0 + angle : angle > 180.0 ? -360.0 + angle : angle
            return angle < -halfLength ? length + angle : angle > halfLength ? -length + angle : angle
        case .latitude:
            //        return angle < -90.0 ? -180.0 - angle : angle > 90.0 ? 180.0 - angle : angle
            return angle < -halfLength ? -length - angle : angle > halfLength ? length - angle : angle
        }
    }
}

