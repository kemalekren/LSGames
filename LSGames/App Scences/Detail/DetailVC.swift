//
//  DetailVC.swift
//  LSGames
//
//  Created by Kemal Ekren on 25.04.2021.
//

import UIKit

final class DetailVC: UIViewController {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var activiyView: UIView!
    @IBOutlet weak var activiyIndicator: UIActivityIndicatorView!
    
    private var gradientLayer : CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.frame = CGRect.zero
        return layer
    }()
    
    var vm: DetailVM! {
        didSet{
            vm.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        activiyIndicator.startAnimating()
    }
    
    private func setupView() {
        gradientLayer.shouldRasterize = true
        containerView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = containerView.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favourite", style: .plain, target: self, action: #selector(addFavorite))
    }
    
    
    @objc private func addFavorite() {
        vm.addToFavoriteWith()
    }
    
    
    @IBAction func visitRedditAction(_ sender: Any) {
        if let url = vm.redditLink,
           let link = URL(string: url) {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func visitWebsiteAction(_ sender: Any) {
        if let url = vm.webSiteLink,
           let link = URL(string: url) {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
    private func getImage(data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        
        return UIImage(named: "no-image")
    }
}

extension DetailVC: DetailVMOutputDelegate {
    func updateItem(_ item: DetailPresentation) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.gameTitle.text = item.gameName
            self.navigationItem.rightBarButtonItem?.title = self.vm.isFavorite
                ? "Favorited"
                : "Favorite"
            self.gameDescription.text = item.gameDescription.htmlToString
            
            if let url = item.imageUrl {
                NetworkManager.shared.imageDownload(imageURL: url) { data , error in
                    if let image = self.getImage(data: data) {
                        DispatchQueue.main.async {
                            self.gameImage.image = image
                            self.activiyIndicator.stopAnimating()
                            self.activiyView.alpha = 0
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(type: NetworkError) {
 
    }
    
    func updateNavigationBarItem(_ status: Bool) {
        self.navigationItem.rightBarButtonItem?.title = self.vm.isFavorite
            ? "Favorited"
            : "Favorite"
    }

}
