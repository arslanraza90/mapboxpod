//
//  PlacesResponse.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/20/23.
//

import Foundation

struct PlacesResponse: Codable {
    let results: [Results]
}

struct Results : Codable {
    let geometry : Geometry?
    let name : String?
    let photos : [Photos]?
    let place_id : String?
    let rating : Double?
    let user_ratings_total : Int?
    let opening_hours : Opening_hours?
    
    enum CodingKeys: String, CodingKey {
        case geometry = "geometry"
        case name = "name"
        case photos = "photos"
        case place_id = "place_id"
        case rating = "rating"
        case user_ratings_total = "user_ratings_total"
        case opening_hours = "opening_hours"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        geometry = try values.decodeIfPresent(Geometry.self, forKey: .geometry)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        photos = try values.decodeIfPresent([Photos].self, forKey: .photos)
        place_id = try values.decodeIfPresent(String.self, forKey: .place_id)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        user_ratings_total = try values.decodeIfPresent(Int.self, forKey: .user_ratings_total)
        opening_hours = try values.decodeIfPresent(Opening_hours.self, forKey: .opening_hours)
    }
}

struct Geometry : Codable {
    let location : Location?
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent(Location.self, forKey: .location)
    }
}

struct Location : Codable {
    let lat : Double?
    let lng : Double?
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
    }
}

struct Photos : Codable {
    let height : Int?
    let html_attributions : [String]?
    let photo_reference : String?
    let width : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case height = "height"
        case html_attributions = "html_attributions"
        case photo_reference = "photo_reference"
        case width = "width"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        html_attributions = try values.decodeIfPresent([String].self, forKey: .html_attributions)
        photo_reference = try values.decodeIfPresent(String.self, forKey: .photo_reference)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
    }
}

struct Opening_hours : Codable {
    let open_now : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case open_now = "open_now"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        open_now = try values.decodeIfPresent(Bool.self, forKey: .open_now)
    }
    
}

struct PlaceDetailsResponse: Codable {
    let result: PlaceDetails?
}

struct PlaceDetails : Codable {
    let name: String?
    let formatted_phone_number: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case formatted_phone_number = "formatted_phone_number"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        formatted_phone_number = try values.decodeIfPresent(String.self, forKey: .formatted_phone_number)
    }
}
