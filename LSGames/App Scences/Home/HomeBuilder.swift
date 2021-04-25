//
//  HomeBuilder.swift
//  LSGames
//
//  Created by Kemal Ekren on 24.04.2021.
//

import UIKit

final class HomeBuilder {

    static func make()-> HomeVC {
        let storyBoard = UIStoryboard(name: "HomeVC", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        viewController.vm = HomeVM()
        return viewController
    }
}
