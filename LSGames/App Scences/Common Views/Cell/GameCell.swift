//
//  GameCell.swift
//  LSGames
//
//  Created by Kemal Ekren on 24.04.2021.
//

import UIKit

final class GameCell: UICollectionViewCell {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var metacriticLabel:UILabel!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameScore: UILabel!
    @IBOutlet weak var gameCategory: UILabel!
    
    var model: HomePresentation! {
        didSet{
            if let url = model.gameImageUrl {
                NetworkManager.shared.downloadImage(from: url) { [weak self] (image) in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        if let image = image {
                            self.gameImage.image = image
                        }else {
                            self.gameImage.image = nil
                        } 
                    }
                }
            } else {
                self.gameImage.image = nil
            }
            
            gameTitle.text = model.gameTitle
            if model.gameScore.isEmpty {
                gameScore.isHidden = true
                metacriticLabel.isHidden = true
            }else {
                gameScore.text = model.gameScore
            }
          
            gameCategory.text = model.gameGenre
        }
    }
}
