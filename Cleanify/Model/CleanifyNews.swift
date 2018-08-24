//
//  CleanifyNews.swift
//  Cleanify
//
//  Created by Kevin Wijaya on 24/08/18.
//  Copyright © 2018 Daniel Gunawan. All rights reserved.
//

import Foundation
struct CleanifyNew: Codable {
    let id: Int
    let title: String
    let body: String
    let description: String
    let photoUrl: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case title = "title"
        case body = "body"
        case description = "description"
        case photoUrl = "photo_url"
        case createdAt = "created_at"
    }
}
