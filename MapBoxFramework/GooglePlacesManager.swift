//
//  GooglePlacesManager.swift
//  mapboxpod
//
//  Created by Arslan Raza on 01/03/2023.
//

import Foundation
import GooglePlaces
import CoreLocation

struct Place: Codable {
    let name: String
    let identifier: String
}

final class GooglePlacesManager {
    
    static let shared = GooglePlacesManager()
    private let client = GMSPlacesClient.shared()
    
    private init() {}
    
    enum PlacesError: Error {
        case failedToFind
        case failedToGetCoordintes
    }
    
    public func setUp() {
        
    }
    
    public func findPlaces(query: String, origin: CLLocationCoordinate2D, completion: @escaping (Result<[Place], Error>) -> Void) {
        
        let filter = GMSAutocompleteFilter()
//        filter.type = .geocode
        filter.types = [""]
        let searchBound: Double = 2.0
        let northEastBounds = CLLocationCoordinate2D(latitude: origin.latitude + searchBound, longitude: origin.longitude + searchBound)
        let southWestBounds = CLLocationCoordinate2D(latitude: origin.latitude - searchBound, longitude: origin.latitude - searchBound)
        filter.locationBias = GMSPlaceRectangularLocationOption(northEastBounds, southWestBounds)
        
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlacesError.failedToFind))
                return
            }
            
            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string, identifier: $0.placeID)
            })
            completion(.success(places))
        }
    }
    
    public func resolveLocation(for place: Place, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void ) {
        client.fetchPlace(fromPlaceID: place.identifier, placeFields: .coordinate, sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failedToGetCoordintes))
                return
            }
            
            let cordinate = CLLocationCoordinate2DMake(googlePlace.coordinate.latitude, googlePlace.coordinate.longitude)
            completion(.success(cordinate))
        }
    }
    
}

