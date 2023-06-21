//
//  Constants.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/1/23.
//

import Foundation

let TURN_LOCATION_TEXT = "Turn on Location Services to Allow App to determine your current location."
let ORIGIN_LOCATION_TEXT = "Please select your current location as origin."
let DESTINATION_LOCATION_TEXT = "Please select the destination other than your current location."
let PLACES_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
let PLACES_DETAILS = "https://maps.googleapis.com/maps/api/place/details/json"
let API_KEY = "AIzaSyAMlml7aqa1BQRUnmmmgixmFoDR3mdpRUI"

enum PlacesType: String {
    case grocerystore = "supermarket|grocery_or_supermarket|store|department_store"
    case restaurant = "restaurant"
    case gasStations = "gas_station"
    
    var image: String {
        switch self {
        case .grocerystore:
            return "grocery"
        case .restaurant:
            return "restaurant"
        case .gasStations:
            return "gas"
        }
    }
}

enum PlaceFilterType {
    case All, TopRated, Open
}

class Category {
    var name: String
    var image: String
    var isselected: Bool
    var type: PlacesType
    
    init(name: String, image: String, isselected: Bool, type: PlacesType) {
        self.name = name
        self.image = image
        self.isselected = isselected
        self.type = type
    }
    
}

var allCategories: [Category] = [Category(name: "Grocery store", image: "grocery", isselected: false, type: .grocerystore),
                                 Category(name: "Restaurants", image: "restaurant", isselected: false, type: .restaurant),
                                 Category(name: "Gas Stations", image: "gas", isselected: false, type: .gasStations)]
