//
//  HomeContracts.swift
//  LSGames
//
//  Created by Kemal Ekren on 24.04.2021.
//

import Foundation

protocol HomeVMProtocol: class {
    var delegate: HomeVMOutputDelegate? { get set }
    func loadWith(_ query: String)
    func loadNextPage()
}

protocol HomeVMOutputDelegate: class {
    func updateItems(_ items:[HomePresentation])
}
