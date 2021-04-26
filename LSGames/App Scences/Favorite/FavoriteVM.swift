//
//  FavoriteVM.swift
//  LSGames
//
//  Created by Kemal Ekren on 26.04.2021.
//

import Foundation

final class FavoriteVM: FavoriteVMProtocol {
    weak var delegate: FavoriteVMOutputDelegate?
    
    func load() {
        PersistanceManager.retrieveFavorites { (result) in
            switch result {
            case .success(let items):
                self.delegate?.updateItems(items)
            case .failure(let error):
                self.delegate?.showAlert(type: .noData)
            }
        }
    }
    
    func deleteFavoriteWith(_ item: HomePresentation) {
        PersistanceManager.updateWith(favorite: item, actionType: .remove) { (error) in
            print(error)
        }
    }
}
