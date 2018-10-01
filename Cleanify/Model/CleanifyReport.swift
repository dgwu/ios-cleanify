//
//  CleanifyReport.swift
//  Cleanify
//
//  Created by Andre Tirta Wijaya on 27/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import Foundation

struct CleanifyReport:Codable{
    let id:Int
    let title:String
    let body:String
    let description:String
    let photo_url:String
    let location_desc:String
    let location_latitude:Double
    let location_longitude:Double
    let created_at:String
    let status:String
    
    enum CodingKeys:String,CodingKey{
        case id = "id"
        case title = "title"
        case body = "body"
        case description = "description"
        case photo_url = "photo_url"
        case location_desc = "location_desc"
        case location_latitude = "location_latitude"
        case location_longitude = "location_longitude"
        case created_at = "created_at"
        case status = "status"
    }
}
