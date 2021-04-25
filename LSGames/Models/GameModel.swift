//
//  GameModel.swift
//  LSGames
//
//  Created by Kemal Ekren on 24.04.2021.
//

import Foundation

struct GameResponse: Codable {
    let nextPage: String?
    let previousPage: String?
    let results: [GameModel]
    
    private enum CodingKeys: String, CodingKey {
        case nextPage = "next"
        case previousPage = "previous"
        case results
    }
}

struct GameModel: Codable {
    let id: Int
    let name: String
    let image: String?
    let score: Int?
    let genres: [Genre]
    
    private enum CodingKeys: String, CodingKey {
        case id,name,genres
        case image = "background_image"
        case score = "metacritic"        
    }
}

struct Genre: Codable {
    let name: String
}
