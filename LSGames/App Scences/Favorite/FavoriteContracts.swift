//
//  FavoriteContracts.swift
//  LSGames
//
//  Created by Kemal Ekren on 26.04.2021.
//

import Foundation

protocol FavoriteVMProtocol: class {
    var delegate: FavoriteVMOutputDelegate? { get set }
    func load()
    func deleteFavoriteWith(_ item: HomePresentation)
}

protocol FavoriteVMOutputDelegate: class {
    func updateItems(_ items:[HomePresentation])
    func showAlert(type: NetworkError)
}

