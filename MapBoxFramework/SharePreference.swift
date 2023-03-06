//
//  SharePreference.swift
//  mapboxpod
//
//  Created by Arslan Raza on 06/03/2023.
//

import Foundation

open class SharePreference: NSObject {
    
    public static let shared = SharePreference()
    let defaults = UserDefaults.standard
    
    func setSelectedPlaces(_ place: [Place]) {

        let placeData = try! JSONEncoder().encode(place)
        defaults.set(placeData, forKey: "placesArray")
    }
    
    func getSelectedPlaces() -> [Place]? {
        let placesData = UserDefaults.standard.data(forKey: "placesArray")
        if let placesData = placesData {
            do {
                let placeArray = try JSONDecoder().decode([Place].self, from: placesData)
                return placeArray
            } catch {
                print("error")
            }
        }
        return nil
    }
}

