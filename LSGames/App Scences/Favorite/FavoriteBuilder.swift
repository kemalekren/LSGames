//
//  FavoriteBuilder.swift
//  LSGames
//
//  Created by Kemal Ekren on 26.04.2021.
//

import UIKit

final class FavoriteBuilder {

    static func make()-> FavoriteVC {
        let storyBoard = UIStoryboard(name: "FavoriteVC", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "FavoriteVC") as! FavoriteVC
        viewController.vm = FavoriteVM()
        return viewController
    }
}

