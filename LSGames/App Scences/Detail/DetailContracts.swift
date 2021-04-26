//
//  DetailContracts.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import Foundation

protocol DetailVMProtocol: class {
    var delegate: DetailVMOutputDelegate? { get set }
    var redditLink: String? { get }
    var webSiteLink: String? { get }
    var isFavorite: Bool { get }
    func load()
    func addToFavoriteWith()
   
}

protocol DetailVMOutputDelegate: class {
    func updateItem(_ item: DetailPresentation)
    func updateNavigationBarItem(_ status: Bool)
}
