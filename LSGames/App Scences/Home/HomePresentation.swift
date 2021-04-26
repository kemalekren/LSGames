//
//  HomePresentation.swift
//  LSGames
//
//  Created by Kemal Ekren on 24.04.2021.
//

import Foundation

struct HomePresentation: Codable {
    
    private let gameModel: GameModel
    
    init(gameModel: GameModel) {
        self.gameModel = gameModel
    }
    
    var gameId: Int {
        return gameModel.id
    }
    
    var gameTitle: String {
        return gameModel.name
    }
    
    var gameGenre: String {
        let genreString = gameModel.genres
            .map {$0.name}
            .joined(separator: ",")
        return genreString
    }
    
    var gameScore: String {
        if let score = gameModel.score {
            return String(score)
        }
        return ""
    }
    
    var gameImageUrl: String? {
        return gameModel.image
    }
}
