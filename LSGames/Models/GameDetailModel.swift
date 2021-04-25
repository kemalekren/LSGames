//
//  GameDetailModel.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import Foundation

struct GameDetailModel: Codable {
    let id: String
    let name: String
    let description: String?
    let redditUrl: String?
    let websiteUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case id,name,description
        case redditUrl = "reddit_url"
        case websiteUrl = "website"
    }
}
