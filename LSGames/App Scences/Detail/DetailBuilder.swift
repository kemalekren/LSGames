//
//  DetailBuilder.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import UIKit

final class DetailBuilder {

    static func make()-> DetailVC {
        let storyBoard = UIStoryboard(name: "DetailVC", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
//        viewController.vm = HomeVM()
        return viewController
    }
}

