//
//  DetailVM.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import Foundation

final class DetailVM: DetailVMProtocol {
    weak var delegate: DetailVMOutputDelegate?
    var webSiteLink: String?
    var redditLink: String?
    
    var isFavorite: Bool = false
    
    private var item: HomePresentation
    
    init(item: HomePresentation) {
        self.item = item
        checkFavoriteStatus()
        load()
    }
    
    func load() {
        NetworkManager.shared.getGameDetailWith(item.gameId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            
            case .success(let detail):
                self.webSiteLink = detail.websiteUrl
                self.redditLink = detail.redditUrl
                self.delegate?.updateItem(DetailPresentation(model: detail))
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    private func checkFavoriteStatus() {
        PersistanceManager.isFavorite(favorite: item) { (result) in
            self.isFavorite = result
        }
    }
    
    func addToFavoriteWith() {
        if isFavorite {
            PersistanceManager.updateWith(favorite: item, actionType: .remove) { (error) in
                print(error)
                self.isFavorite = false
            }
        } else {
            PersistanceManager.updateWith(favorite: item, actionType: .add) { (error) in
                print(error)
                self.isFavorite = true
            }
        }
        delegate?.updateNavigationBarItem(isFavorite)
    }
}
