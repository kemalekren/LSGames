//
//  LSTabBarController.swift
//  LSGames
//
//  Created by Kemal Ekren on 24.04.2021.
//

import UIKit

private enum VCTypes: String {
    case home, favorite
}

final class LSTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().prefersLargeTitles = true
        viewControllers = [createVCs(type: .home), createVCs(type: .favorite)]
    }
    
    private func createVCs(type: VCTypes) -> UINavigationController {
        switch type {
        case .home:
            let homeVC = HomeBuilder.make()
            homeVC.title = "Games"
            homeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
            
            return UINavigationController(rootViewController: homeVC)
        case .favorite:
            let favoriteVC = FavoriteVC()
            favoriteVC.title = "Favorite"
            favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
            
            return UINavigationController(rootViewController: favoriteVC)
        }
    }
}

