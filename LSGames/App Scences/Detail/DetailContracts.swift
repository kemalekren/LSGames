//
//  DetailContracts.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import Foundation

protocol DetailVMProtocol: class {
    var delegate: HomeVMOutputDelegate? { get set }
    func load()
    func loadNextPage()
}

protocol DetailVMOutputDelegate: class {
    func updateItems(_ items:[DetailPresentation])
    func showAlert(type: NetworkError)
}
