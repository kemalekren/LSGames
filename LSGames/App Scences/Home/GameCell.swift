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
    
    private func getImage(data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        
        return UIImage(named: "no-image")
    }
    
    var model: HomePresentation! {
        didSet{
            NetworkManager.shared.imageDownload(imageURL: model.gameImageUrl) { data , error in
                if let image = self.getImage(data: data) {
                    DispatchQueue.main.async {
                        self.gameImage.image = image
                    }
                }
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
