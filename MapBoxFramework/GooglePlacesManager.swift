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

public struct PlaceVisit: Codable {
    public let locationName: String
    public let date: Date
    public let source: String
    public let id: String
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
    
    
    func getNearestLocation(placeType: PlacesType, locationCoordinate: CLLocationCoordinate2D, completion: @escaping ([Results]?, Error?) -> Void) {
        let location = "\(locationCoordinate.latitude), \(locationCoordinate.longitude)"
        var urlComponents = URLComponents(string: PLACES_URL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "location", value: location),
            URLQueryItem(name: "radius", value: "5000"),
            URLQueryItem(name: "types", value: placeType.rawValue),
            URLQueryItem(name: "key", value: API_KEY)
        ]
        guard let url = urlComponents?.url else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 0, userInfo: nil))
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                let decoder = JSONDecoder()
                let response = try decoder.decode(PlacesResponse.self, from: data)
                completion(response.results, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func findPlaceDetails(_ placeId: String, completion: @escaping (PlaceDetailsResponse?, Error?) -> Void) {
        let fields = "name,formatted_phone_number"
        var urlComponents = URLComponents(string: PLACES_DETAILS)
        urlComponents?.queryItems = [
            URLQueryItem(name: "place_id", value: placeId),
            URLQueryItem(name: "fields", value: fields),
            URLQueryItem(name: "key", value: API_KEY)
        ]
        
        guard let url = urlComponents?.url else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 0, userInfo: nil))
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                let decoder = JSONDecoder()
                let placeDetails = try decoder.decode(PlaceDetailsResponse.self, from: data)
                completion(placeDetails, nil)
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil, error)
            }
        }
        task.resume()
    }
}

