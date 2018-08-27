//
//  CleanifyEvent.swift
//  Cleanify
//
//  Created by Daniel Gunawan on 23/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import Foundation

struct CleanifyEvent: Codable {
    let id: Int
    let title: String
    let body: String
    let description: String
    let heldAt: String
    let locationDesc: String
    let locationLatitude: Double
    let locationLongitude: Double
    let photoURL: String
    var isParticipated: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case body = "body"
        case description = "description"
        case heldAt = "held_at"
        case locationDesc = "location_desc"
        case locationLatitude = "location_latitude"
        case locationLongitude = "location_longitude"
        case photoURL = "photo_url"
        case isParticipated = "is_participated"
    }
}
