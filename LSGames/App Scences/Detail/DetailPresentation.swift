//
//  DetailPresentation.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import Foundation

struct DetailPresentation {
    private let model: GameDetailModel
    
    init(model: GameDetailModel) {
        self.model = model
    }
    
    var gameId: Int {
        return model.id
    }
    
    var gameName: String {
        return model.name
    }
    
    var imageUrl: String? {
        return model.imageUrl
    }
    
    var gameDescription: String {
        return model.description ?? ""
    }
    
    var redditLink: String {
        return model.redditUrl ?? ""
    }
    
    var websiteLink: String {
        return model.websiteUrl ?? ""
    }
}
